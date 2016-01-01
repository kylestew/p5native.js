import UIKit
import JavaScriptCore

// JS code loading
let context = JSContext()
context.evaluateScript("var num = 5 + 5")
context.evaluateScript("var names = ['Grace', 'Ada', 'Margaret']")
context.evaluateScript("var triple = function(value) { return value * 3 }")

// JS -> function return out
let tripleNum:JSValue = context.evaluateScript("triple(num)")
let intVal = tripleNum.toInt32() // as Int32

// JS -> value out
let names = context.objectForKeyedSubscript("names")
let initialName = names.objectAtIndexedSubscript(0)

// native -> call JS func
let tripleFunction = context.objectForKeyedSubscript("triple")
let result = tripleFunction.callWithArguments([5])

// JS -> exposing native Swift method to JS
let simplifyString: @convention(block) String -> String = { input in
    let result = input.stringByApplyingTransform(NSStringTransformToLatin, reverse: false)
    return result?.stringByApplyingTransform(NSStringTransformStripCombiningMarks, reverse: false) ?? ""
}
context.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "simplifyString")
print(context.evaluateScript("simplifyString('안녕하새요')"))


@objc protocol PersonJSExports : JSExport {
    var firstName:String { get set }
    var lastName:String { get set }
    var birthYear:NSNumber? { get set }
    
    func getFullName() -> String
    
    static func createWithFirstName(firstName: String, lastName: String) -> Person
}

@objc class Person : NSObject, PersonJSExports {
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var birthYear: NSNumber?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    class func createWithFirstName(firstName: String, lastName: String) -> Person {
        return Person(firstName: firstName, lastName: lastName)
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}



/*

function setup() {
}

// native needs to call draw()
function draw() {
// js needs to call native draw funcs
ellipse(50, 50, 80, 80);
}

*/
