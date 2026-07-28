import Foundation
import Capacitor
import StoreKit

// Asks iOS for an Apple Music user token, natively.
//
// Why this exists: MusicKit JS gets the same token by opening Apple's sign-in in a
// popup window. Capacitor hands popups to the system browser, which severs the link
// back to our webview -- the user approves, and the app never hears about it. There
// is no web-side fix for that, so inside the app we skip the web flow entirely.
//
// Everything after this is unchanged: the token goes straight into the existing
// Apple Music REST calls as the Music-User-Token header.
@objc(AppleMusicAuthPlugin)
public class AppleMusicAuthPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AppleMusicAuthPlugin"
    public let jsName = "AppleMusicAuth"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "userToken", returnType: CAPPluginReturnPromise)
    ]

    // Held as a property deliberately. A controller created inline can be released
    // before requestUserToken's completion handler fires, and the callback then never
    // arrives -- which is the exact silent hang this plugin is here to get rid of.
    private let controller = SKCloudServiceController()

    @objc func userToken(_ call: CAPPluginCall) {
        guard let developerToken = call.getString("developerToken"), !developerToken.isEmpty else {
            call.reject("No developer token was passed.", "NO_DEV_TOKEN")
            return
        }

        // This is the system permission sheet -- it shows Sift's real name and icon,
        // and its wording comes from NSAppleMusicUsageDescription in Info.plist.
        // Note: requestAuthorization CRASHES if that key is missing.
        SKCloudServiceController.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            guard status == .authorized else {
                // denied / restricted / notDetermined -- their choice, not a failure
                call.reject("Apple Music access was not granted.", "DENIED")
                return
            }
            self.controller.requestUserToken(forDeveloperToken: developerToken) { token, error in
                if let error = error {
                    call.reject(error.localizedDescription, "TOKEN_FAILED", error)
                    return
                }
                guard let token = token, !token.isEmpty else {
                    call.reject("Apple returned no user token.", "TOKEN_FAILED")
                    return
                }
                call.resolve(["token": token])
            }
        }
    }
}
