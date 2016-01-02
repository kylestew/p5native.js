import UIKit
import p5native

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: Canvas!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let example = "structure_recursion"
        
        if let filepath = NSBundle.mainBundle().pathForResource(example, ofType: "js") {
            do {
                let jsCode = try! String(contentsOfFile: filepath, encoding: NSUTF8StringEncoding)
                canvasView.loadJavascript(jsCode)
            }
        }
    }
    
}

