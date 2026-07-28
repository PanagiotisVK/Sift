import UIKit
import Capacitor

// Capacitor discovers plugins that ship as packages on its own, but one defined
// inside the app has to be handed to the bridge by hand. That's all this class is
// for. Main.storyboard points at it instead of the stock CAPBridgeViewController.
class MainViewController: CAPBridgeViewController {
    override func capacitorDidLoad() {
        bridge?.registerPluginInstance(AppleMusicAuthPlugin())
    }
}
