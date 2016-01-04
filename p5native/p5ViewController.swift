import UIKit
import WebKit

public protocol p5PropsDelegate {
    func p5PropUpdated(key: String, value: AnyObject)
    func p5PropBound(binding: NSDictionary)
}

public class p5ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    public var propsDelegate:p5PropsDelegate?
    
    var webView:WKWebView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "props")
        controller.addScriptMessageHandler(self, name: "propRegistration")
       
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        if let wv = webView {
            wv.navigationDelegate = self
            view.addSubview(wv)
            wv.scrollView.bounces = false // lock down scroll
            
            
            
        }
    }
    
    public func loadp5Script(javascript: String) {
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
        webView?.evaluateJavaScript("receivePropUpdate(\"\(key)\", \(value))") { (value, error) in
            print(error)
        }
    }
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let delegate = propsDelegate {
            
            if (message.name == "propRegistration") {
                
                if let binding = message.body as? NSDictionary {
                    delegate.p5PropBound(binding)
                }
                
            } else {
                
                if let props = message.body as? [String:AnyObject] {
                    
                    print(props)
                    
//                for prop in props {
//                    if (prop.0 == "propBindings") {
//                        // pass to bindings callback
//                        if let bindings = prop.1 as? [[String:String]] {
//                            delegate.p5PropBindings(bindings)
//                        }
//                    } else {
//                        // standard prop update
//                        delegate.p5PropUpdated(prop.0, value: prop.1)
//                    }
//                }
                    
                }
                
            }
            
        }
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
        assert(true)
    }
    
}