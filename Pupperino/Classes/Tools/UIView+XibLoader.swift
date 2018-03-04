
import UIKit

extension UIView {
    
    @discardableResult func loadContentFromNib<T: UIView>() -> T? {

        let name = String(describing: type(of: self)).components(separatedBy: ".").first ?? ""
        guard let nibs = Bundle.main.loadNibNamed(name, owner: self, options: nil) else {
            print("nib named `\(name)` does not exist")
            return nil
        }
        
        guard let view = nibs[0] as? T else {
            print("view kind of `\(T.self)` does not exist")
            return nil
        }
        
        self.addSubview(view)

        view.pinViewToEdgesOf(parentView: self)
        return view
    }
}
