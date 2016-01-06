import UIKit
import WebKit

public protocol p5PropsDelegate {
    func p5PropUpdated(key: String, value: AnyObject)
    func p5PropBound(binding: NSDictionary)
}

public class p5ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    public var propsDelegate:p5PropsDelegate?
    
    var webView:WKWebView?
    var canvasSize = CGSizeZero
    
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
    
    var script:String?
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        canvasSize = view.bounds.size
        if let script = script {
            loadScript(script)
        }
    }
    
    public func loadp5Script(javascript: String) {
        // save until we have proper view size
        script = javascript
    }
    
    func loadScript(var script: String) {
        // basic html5 environment with p5js
        if let webView = webView {
            if let indexURL = NSBundle(forClass: self.dynamicType).URLForResource("index", withExtension: "html") {
                webView.loadFileURL(indexURL, allowingReadAccessToURL: indexURL)
                
                // inject view size into p5 script
                if let match = script.rangeOfString("(createCanvas\\s?)(\\([^\\)]*\\))", options: .RegularExpressionSearch) {
                    var str = script.substringWithRange(match)
                    str = str.stringByReplacingOccurrencesOfString(" ", withString: "")
                    str = str.stringByReplacingOccurrencesOfString("createCanvas(", withString: "")
                    str = str.stringByReplacingOccurrencesOfString(")", withString: "")
                    let args = str.componentsSeparatedByString(",")
                    var replace:String
                    if (args.count == 3) {
                        replace = "createCanvas(\(Int(canvasSize.width)),\(Int(canvasSize.height)),\(args[2]))"
                    } else {
                        replace = "createCanvas(\(Int(canvasSize.width)),\(Int(canvasSize.height)))"
                    }
                    script.replaceRange(match, with: replace)
                }
                
                webView.evaluateJavaScript(script, completionHandler: { (object, error) -> Void in
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
                    for (key, value) in props {
                        delegate.p5PropUpdated(key, value: value)
                    }
                }
                
            }
            
        }
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error)
        assert(true)
    }
    
}