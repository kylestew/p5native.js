import UIKit
import JavaScriptCore

@objc protocol CanvasJSExports : JSExport {
    var width:Double { get set }
    var height:Double { get set }
    func noLoop()
}

public class Canvas: UIView, CanvasJSExports {
    // ================================================================
    // MARK: === Processing Library Commands ==========================
    // ================================================================
    // TODO: better way to make sure I don't miss these?
    // these are the functions we expose on the global namespace - polluting like a boss
    static let jsExports = [
        // Canvas
        "width",
        "height",
        "noLoop",
        
        // 2DPrimitives
        "ellipse",
        "rect",
        
        // Color
        "background",
        "noFill",
        "fill",
        "noStroke",
        "stroke",
        
        // Rendering
        "createCanvas",
    ]
    
    // some features of p5.js don't make sense on mobile
    func nop(funcName: String) {
        print("NOT IMPLEMENTED: \(funcName)")
    }
    
    // MARK: 3D Primitives
    
    // MARK: 2D Primitives
    
    // MARK: Attributes
    var _strokeWeight = 1.0
    enum RectMode {
        case CORNER
        case CENTER
    }
    var rectMode = RectMode.CORNER
    enum EllipseMode {
        case RADIUS
        case CENTER
        case CORNER
        case CORNERS
    }
    var ellipseMode = EllipseMode.RADIUS
    
    // MARK: Vertex
    var shapeEmpty = true
    var drawingShape = false
    
    // MARK: Transform
    
    // MARK: Color
    enum ColorMode {
        case RGB
        case HSB
    }
    var colorMode = ColorMode.RGB
    var v1Max = 255.0
    var v2Max = 255.0
    var v3Max = 255.0
    var alphaMax = 1.0
    var fillEnabled = true
    var _fillColor = UIColor.whiteColor()
    var strokeEnabled = true
    var _strokeColor = UIColor.blackColor()
    var drawingMode:CGPathDrawingMode {
        get {
            if (strokeEnabled && fillEnabled) {
                return .FillStroke
            } else if (fillEnabled) {
                return .Fill
            } else {
                return .Stroke
            }
        }
    }
    // use after overriding color mode
    func resetColorMode() {
        CGContextSetFillColorWithColor(drawCTX, _fillColor.CGColor)
        CGContextSetStrokeColorWithColor(drawCTX, _strokeColor.CGColor)
    }
    
    // MARK: Structure
    func noLoop() {
        // just pause displayLink
        displayLink.paused = true
    }
    
    // MARK: Math
    let PI = 3.1415926536
    let TWO_PI = 6.2831853072
    
    // ================================================================
    // MARK: ==========================================================
    // ================================================================
    
    let jsContext = JSContext()
    var jsSetup:JSValue?
    var jsDraw:JSValue?
    
    // MARK: JS resource loading
    public func loadJavascript(javascript: String) {
        // preprocess all exposed calls to add a "_."
        var js = javascript
        for export in Canvas.jsExports {
            js = js.stringByReplacingOccurrencesOfString(export, withString: "_.\(export)")
        }
        
        // bind Swift code for JS use
        jsContext.setObject(self, forKeyedSubscript: "_")
        
        // load JS
        jsContext.evaluateScript(js)
        
        // get handles to lifecycle methods
        jsSetup = jsContext.objectForKeyedSubscript("setup")
        jsDraw = jsContext.objectForKeyedSubscript("draw")
        if (jsDraw?.toString() == "undefined") {
            jsDraw = nil
        }
        
        // setup exception handling for dev
        jsContext.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        
        if (jsDraw != nil) {
            // start run loop
            run()
        }
    }
    
    // MARK: Animation loop
    private var displayLinkAttached = false
    lazy private var displayLink:CADisplayLink = {
        return CADisplayLink(target: self, selector: Selector("displayLinkUpdate"))
    }()
    private var nextDeltaTimeZero = true
    private var previousTimestamp:NSTimeInterval = 0
    private var deltaTime:NSTimeInterval = 0
    
    deinit {
        if (displayLinkAttached) {
            displayLink.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
    }
    
    var elapsedTime = 0.0
    var startTime = 0.0;
    var started = false
    func run() {
        // start run loop
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLinkAttached = true
        displayLink.frameInterval = 2 // 30FPS
        
        // mark start of run
        startTime = displayLink.timestamp
        
        started = true
    }
    
    func displayLinkUpdate() {
        let currentTime:NSTimeInterval = displayLink.timestamp
        deltaTime = currentTime - previousTimestamp
        if (nextDeltaTimeZero) {
            deltaTime = 0.0
            nextDeltaTimeZero = false
        }
        previousTimestamp = currentTime
        
        frameCount++
        
        elapsedTime = displayLink.timestamp - startTime
        
        self.setNeedsDisplay()
    }
    
    var drawCTX:CGContext?
    var drawRect = CGRectZero
    var width = 0.0
    var height = 0.0
    var frameCount = 0
    var hasSetup = false
//    var snapshot:UIImage?
    public override func drawRect(rect: CGRect) {
        drawCTX = UIGraphicsGetCurrentContext()
        drawRect = rect
        width = Double(drawRect.width)
        height = Double(drawRect.height)
        
        // run setup once, or if no draw() method - redisplay setup
        // TODO: run setup/rest again if display size changes
        if (!hasSetup || jsDraw != nil) {
//            self.touchPoint = Point(self.width/2, self.height/2)

            jsSetup?.callWithArguments([])
            hasSetup = true
        }
        
        // draw snapshot
//        if let snap = snapshot {
//            snap.drawInRect(rect)
//        }
        
        // call draw on all modules (in order)
        jsDraw?.callWithArguments([])
        
        // TODO: optimize
        // take snapshot
//        UIGraphicsBeginImageContext(rect.size);
//        layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        snapshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
    }

}
