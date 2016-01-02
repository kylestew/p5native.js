import UIKit
import JavaScriptCore

@objc protocol _2DPrimitivesExports : JSExport {
    func ellipse(a: Double, _ b: Double, _ c: Double, _ d: Double)
    
    func rect(x: Double, _ y: Double, _ w: Double, _ h: Double)
}

extension Canvas : _2DPrimitivesExports {
    
    // arc()
    
    func ellipse(a: Double, _ b: Double, _ c: Double, _ d: Double) {
        // default is CENTER mode
        let rect = CGRectMake(CGFloat(a-c/2), CGFloat(b-d/2), CGFloat(c), CGFloat(d))
        // TODO: implement other rect modes
        CGContextAddEllipseInRect(drawCTX, rect)
//        if !drawingShape { // draw now
            CGContextDrawPath(drawCTX, drawingMode)
//        }
    }
    
//    func line(x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
//        CGContextMoveToPoint(drawCTX, CGFloat(x1), CGFloat(y1))
//        CGContextAddLineToPoint(drawCTX, CGFloat(x2), CGFloat(y2))
//        CGContextStrokePath(drawCTX)
//    }
//    
//    func point(x: Double, _ y: Double) {
//        // points are circles filled with current stroke mode and a radius of strokeWeight
//        let rad = _strokeWeight/2
//        let rect = CGRectMake(CGFloat(x-rad), CGFloat(y-rad), CGFloat(rad*2), CGFloat(rad*2))
//        
//        // need to mangle stroke/fill modes
//        CGContextSetFillColorWithColor(drawCTX, _strokeColor.CGColor)
//        
//        CGContextFillEllipseInRect(drawCTX, rect)
//        
//        // unmangle
//        resetColorMode()
//    }
//    
//    // quad()
    
    func rect(x: Double, _ y: Double, _ w: Double, _ h: Double) {
        var rect = CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h))
        if (rectMode == RectMode.CENTER) {
            rect.origin.x -= rect.width/2.0
            rect.origin.y -= rect.height/2.0
        }
        CGContextAddRect(drawCTX, rect)
        if !drawingShape { // draw now
            CGContextDrawPath(drawCTX, drawingMode)
        }
    }
    
    
//    // extras
//    func circle(centerX: Double, _ centerY: Double, _ radius: Double) {
//        ellipse(centerX - radius, centerY - radius, radius*2, radius*2)
//    }
//    func triangle(x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ x3: Double, _ y3: Double) {
//        beginShape()
//        vertex(x1, y1)
//        vertex(x2, y2)
//        vertex(x3, y3)
//        endShape()
//    }
    
}
