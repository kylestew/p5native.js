import UIKit
import JavaScriptCore

@objc protocol ColorExports : JSExport {
    func background(color: Int)
    func noFill()
    func fill()
    func noStroke()
    func stroke()
}

extension Canvas : ColorExports {
    
    // TODO: there are like 5 modes for this command, how can we handle that?
    func background(color: Int) {
        UIColor(white: CGFloat(Double(color)/255.0), alpha: 1).setFill()
        UIRectFill(drawRect)
        
        resetColorMode()
    }
    
//    func background(v1: Double, _ v2: Double, _ v3: Double) {
//        let color = makeColor(v1, v2, v3)
//        color.setFill()
//        UIRectFill(drawRect)
//        
//        resetColorMode()
//    }
    
    // clear()
    
//    func colorMode(mode: ColorMode) {
//        colorMode = mode
//    }
//    func colorMode(mode: ColorMode, _ max1: Double) {
//        colorMode = mode
//        v1Max = max1
//    }
//    func colorMode(mode: ColorMode, _ max1: Double, _ max2: Double) {
//        colorMode = mode
//        v1Max = max1
//        v2Max = max2
//    }
//    func colorMode(mode: ColorMode, _ max1: Double, _ max2: Double, _ max3: Double) {
//        colorMode = mode
//        v1Max = max1
//        v2Max = max2
//        v3Max = max3
//    }
    
    func fill() {
        let args = JSContext.currentArguments()
        if (args.count == 1) {
            
            // TODO: could be a string or something else I guess
            
            fillEnabled = true
            _fillColor = UIColor(white: CGFloat(Double(args[0].toDouble()/255.0)), alpha: 1)
            CGContextSetFillColorWithColor(drawCTX, _fillColor.CGColor)
        } else if (args.count == 3) {
            fillEnabled = true
            _fillColor = makeColor(args[0].toDouble(), args[1].toDouble(), args[2].toDouble())
            CGContextSetFillColorWithColor(drawCTX, _fillColor.CGColor)
        } else if (args.count == 4) {
            fillEnabled = true
            _fillColor = makeColor(args[0].toDouble(), args[1].toDouble(), args[2].toDouble(), args[3].toDouble()/255.0)
            CGContextSetFillColorWithColor(drawCTX, _fillColor.CGColor)
        }
    }
//    // HEX inputs only work with RGB mode
//    func fill(hex: Int, _ alpha: Double) {
//        fillEnabled = true
//        _fillColor = UIColor(hex: hex)
//        _fillColor = _fillColor.colorWithAlphaComponent(CGFloat(alpha))
//        CGContextSetFillColorWithColor(drawCTX, _fillColor.CGColor)
//    }
    
    func noFill() {
        fillEnabled = false
        CGContextSetFillColorWithColor(drawCTX, UIColor.clearColor().CGColor)
    }
    
    func noStroke() {
        strokeEnabled = false
        CGContextSetStrokeColorWithColor(drawCTX, UIColor.clearColor().CGColor)
    }
    
    func stroke() {
        let args = JSContext.currentArguments()
        if (args.count == 1) {
//            strokeEnabled = true
//            _strokeColor = color
//            CGContextSetStrokeColorWithColor(drawCTX, _strokeColor.CGColor)
        } else if (args.count == 3) {
            strokeEnabled = true
            _strokeColor = makeColor(args[0].toDouble(), args[1].toDouble(), args[2].toDouble())
            CGContextSetStrokeColorWithColor(drawCTX, _strokeColor.CGColor)
        }
    }
//    // HEX inputs only work with RGB mode
//    func stroke(hex: Int, _ alpha: Double) {
//        strokeEnabled = true
//        _strokeColor = UIColor(hex: hex)
//        _strokeColor = _strokeColor.colorWithAlphaComponent(CGFloat(alpha))
//        CGContextSetStrokeColorWithColor(drawCTX, _strokeColor.CGColor)
//    }
//    func stroke(v1: Double, _ v2: Double, _ v3: Double, _ alpha: Double) {
//        strokeEnabled = true
//        _strokeColor = makeColor(v1, v2, v3, alpha)
//        CGContextSetStrokeColorWithColor(drawCTX, _strokeColor.CGColor)
//    }
    
    
    // MARK: private helper methods
    private func makeColor(v1: Double, _ v2: Double, _ v3: Double) -> UIColor {
        switch colorMode {
        case .RGB:
            return UIColor(red: CGFloat(v1/v1Max), green: CGFloat(v2/v2Max), blue: CGFloat(v3/v3Max), alpha: 1.0)
        case .HSB:
            return UIColor(hue: CGFloat(v1/v1Max), saturation: CGFloat(v2/v2Max), brightness: CGFloat(v3/v3Max), alpha: 1.0)
        }
    }
    private func makeColor(v1: Double, _ v2: Double, _ v3: Double, _ alpha: Double) -> UIColor {
        switch colorMode {
        case .RGB:
            return UIColor(red: CGFloat(v1/v1Max), green: CGFloat(v2/v2Max), blue: CGFloat(v3/v3Max), alpha: CGFloat(alpha/alphaMax))
        case .HSB:
            return UIColor(hue: CGFloat(v1/v1Max), saturation: CGFloat(v2/v2Max), brightness: CGFloat(v3/v3Max), alpha: CGFloat(alpha/alphaMax))
        }
    }
    
}
