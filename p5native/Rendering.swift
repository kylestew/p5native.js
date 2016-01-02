import UIKit
import JavaScriptCore

@objc protocol RenderingExports : JSExport {
    func createCanvas(w: Double, _ h: Double)
}

extension Canvas : RenderingExports {
    
    func createCanvas(w: Double, _ h: Double) {
        nop("createCanvas")
    }

}
