# p5native.js
p5native.js is a collection of libraries that allow [p5.js](https://github.com/processing/p5.js) code to be run natively on iOS.

## Native <--> WKWebView Bridge



Double

Need ReactiveVar style interface with observations

window.webkit.messageHandlers.notification.postMessage({body: "..."});

let js = "getRelatedArticles();"
self.webView?.evaluateJavaScript(js) { (_, error) in
    print(error)
}
