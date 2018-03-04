
import UIKit
import WebKit
import SafariServices

class ClinicsListViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Clinics List".localized
        
        webView.navigationDelegate = self
        let url = URL(string: "http://www.cvinfo.lt/vets-clinics-list")
        let urlRequest = URLRequest(url: url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
    }
    
    // MARK: - UITabBar controller
    static var tabBarController: UIViewController {
        let trackerViewController = ClinicsListViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Clinics List".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}

extension ClinicsListViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlString = webView.url?.absoluteString,
            !urlString.contains("cvinfo.lt") {
            decisionHandler(.cancel)
            openExternalUrl(webView.url!)
            return
        }
        decisionHandler(.allow)
    }
    
    naviga
    
    fileprivate func openExternalUrl(_ url: URL) {
        
        UIApplication.shared.isStatusBarHidden = true
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        if #available(iOS 10.0, *) {
            safariViewController.preferredBarTintColor = .black
            safariViewController.preferredControlTintColor = .white
        }
        
        present(safariViewController, animated: true)
    }
}

extension ClinicsListViewController: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UIApplication.shared.isStatusBarHidden = false
    }
}

