import UIKit
import WebKit

public protocol p5PropsDelegate {
    func p5PropUpdated(key: String, value: AnyObject)
}

public class p5ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    public var propsDelegate:p5PropsDelegate?
    
    var webView:WKWebView?
    
//    public required init?(coder aDecorder:NSCoder) {
//        super.init(coder: aDecorder)
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "props")
        
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        if let wv = webView {
            wv.navigationDelegate = self
            view.addSubview(wv)
        }
    }
    
    public func loadp5Script(javascript: String) {
        
        // TODO: deal with device scaling
        
        // basic html5 environment with p5js
        if let webView = webView {
            if let indexURL = NSBundle(forClass: self.dynamicType).URLForResource("index", withExtension: "html") {
                webView.loadFileURL(indexURL, allowingReadAccessToURL: indexURL)
                webView.evaluateJavaScript(javascript, completionHandler: { (object, error) -> Void in
                    print("p5 script loaded")
                })
            }
        }
    }
    
    public func setProp(key: String, value: AnyObject) {
        webView?.evaluateJavaScript("setProp(\"\(key)\", \(value))") { (value, error) in
            print(error)
        }
    }
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let delegate = propsDelegate {
            if let props = message.body as? [String:AnyObject] {
                print(props)
                for prop in props {
                    print(prop)
                    delegate.p5PropUpdated(prop.0, value: prop.1)
                }
            }
        }
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
    }
    
}