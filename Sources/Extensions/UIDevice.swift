
import UIKit

public extension UIDevice {
    static func isiPad() -> Bool {
        return current.userInterfaceIdiom == .pad
    }
}
