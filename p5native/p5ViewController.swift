import UIKit
import WebKit

public class p5ViewController: UIViewController, WKNavigationDelegate {
    
    let webView:WKWebView
    
    public required init?(coder aDecorder:NSCoder) {
        webView = WKWebView()
        super.init(coder: aDecorder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.frame = self.view.bounds
        view.addSubview(webView)
    }
    
    public func loadp5Script(javascript: String) {
        // basic html5 environment with p5js
        if let indexURL = NSBundle(forClass: self.dynamicType).URLForResource("index", withExtension: "html") {
            webView.loadFileURL(indexURL, allowingReadAccessToURL: indexURL)
            webView.evaluateJavaScript(javascript, completionHandler: { (object, error) -> Void in
                print("p5 script loaded")
            })
        }
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
    }
    
}