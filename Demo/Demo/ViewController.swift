import UIKit
import p5native

class ViewController: UIViewController, p5PropsDelegate {
    
    var p5Controller:p5ViewController?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let controller = p5Controller {
            // load script
            let example = "basic_rect"
            if let filepath = NSBundle.mainBundle().pathForResource(example, ofType: "js") {
                do {
                    let jsCode = try! String(contentsOfFile: filepath, encoding: NSUTF8StringEncoding)
                    controller.loadp5Script(jsCode)
                }
            }
            
            // watch for prop changes we are interested in
            controller.propsDelegate = self
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // grab reference to contained VC
        p5Controller = segue.destinationViewController as? p5ViewController
    }
    
    // MARK: Bindings
    func p5PropUpdated(key: String, value: AnyObject) {
        switch key {
        case "scale":
            if let val = value as? Float {
                slider.value = val
            }
        case "frameCount":
            if let val = value as? Int {
                label.text = "\(val)"
            }
        default: ()
        }
    }
    
    @IBAction func sliderDidChange(slider: UISlider) {
        p5Controller?.setProp("scale", value: slider.value)
    }
    
}

