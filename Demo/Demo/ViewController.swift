import UIKit
import p5native

class ViewController: UIViewController {
    
    var p5Controller:p5ViewController?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let controller = p5Controller {
            let example = "3d_geometries"
            if let filepath = NSBundle.mainBundle().pathForResource(example, ofType: "js") {
                do {
                    let jsCode = try! String(contentsOfFile: filepath, encoding: NSUTF8StringEncoding)
                    controller.loadp5Script(jsCode)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        p5Controller = segue.destinationViewController as? p5ViewController
    }
    
}

