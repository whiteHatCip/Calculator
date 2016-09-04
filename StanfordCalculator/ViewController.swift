//
//  ViewController.swift
//  StanfordCalculator
//
//  Created by Fabio Cipriani on 03/09/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var btn: Button!
    @IBOutlet private weak var resultLbl: UILabel!
    @IBOutlet weak var historyLbl: UILabel!
    
    @IBOutlet weak var invert: Button!
    @IBOutlet weak var factorial: Button!
    @IBOutlet weak var cubic: Button!
    @IBOutlet weak var squared: Button!
    @IBOutlet weak var comma: Button!
    @IBOutlet weak var equals: Button!
    @IBOutlet weak var zero: Button!
    @IBOutlet weak var three: Button!
    @IBOutlet weak var two: Button!
    @IBOutlet weak var one: Button!
    @IBOutlet weak var six: Button!
    @IBOutlet weak var five: Button!
    @IBOutlet weak var four: Button!
    @IBOutlet weak var nine: Button!
    @IBOutlet weak var eight: Button!
    @IBOutlet weak var seven: Button!
    @IBOutlet weak var changeSign: Button!
    @IBOutlet weak var nepero: Button!
    @IBOutlet weak var squareRoot: Button!
    @IBOutlet weak var pi: Button!
    @IBOutlet weak var multiply: Button!
    @IBOutlet weak var divide: Button!
    @IBOutlet weak var minus: Button!
    @IBOutlet weak var plus: Button!
    private var userInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        updateUIElementsAppearance()
    }
    
    @IBAction func commaPressed(_ sender: Button) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            if !resultLbl.text!.contains(digit) {
                appendDigit(".")
            }
        } else {
            resultLbl.text = "0."
        }
        userInTheMiddleOfTyping = true
    }
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        // Check if the user already inserted some digits. If not, set the resultLbl text to the digit inserted, otherwise append the digit to those already inserted
        if userInTheMiddleOfTyping {
            appendDigit(digit)
        } else {
            resultLbl.text = digit
        }
        // User enters in "MiddleOfTyping" mode
        userInTheMiddleOfTyping = true
    }
    
    func appendDigit(_ digit: String) {
        let textCurrentlyInDisplay = resultLbl.text!
        resultLbl.text = textCurrentlyInDisplay + digit
    }
    
    var displayValue: Double? {
        get {
            if let value = resultLbl.text!.replacingOccurrences(of: ".", with: ",").doubleValue {
                return value
            } else {
                return nil
            }
        } set {
            if newValue != nil {
                resultLbl.text = "\(newValue!)"
            } else {
                resultLbl.text = "0"
            }
        }
    }
    
    @IBAction func operationBtnPressed(_ sender: UIButton) {
        // If the user just pressed the . button, no operation is allowed. All brain values and labels are restored
        if resultLbl.text != "," {
            if userInTheMiddleOfTyping {
                // Save the value visible in resultLbl inside the brain accumulator
                brain.setOperand(operand: displayValue!)//Double(resultLbl.text!)!)
                // Once the user presses an operation button, exit "MiddleOfTyping" mode
                userInTheMiddleOfTyping = false
            }
            // Perform selected operation
            if let mathSym = sender.currentTitle {
                brain.performOperation(symbol: mathSym)
            }
            // Checking if the decimal part of the result of the operation is 0, so that the .0 part of the double value is removed from the resultLbl
            let integerPart = Int(brain.result)
            if (Double(integerPart) - brain.result) == 0 {
                resultLbl.text = String(Int(brain.result))
            } else {
                // Display the result rounding the fractional part with 6 decimal digits
                displayValue = brain.result.roundToPlaces(places: 6)
            }
        } else {
            brain.performOperation(symbol: "C")
            clearHistory()
            print(brain.description)
        }
    }
    
    func clearHistory() {
        displayValue = 0
        historyLbl.text = "History"
    }
    
    func updateUIElementsAppearance() {
        btn.roundCornersAndDropShadow()
        plus.roundCornersAndDropShadow()
        minus.roundCornersAndDropShadow()
        divide.roundCornersAndDropShadow()
        multiply.roundCornersAndDropShadow()
        comma.roundCornersAndDropShadow()
        equals.roundCornersAndDropShadow()
        zero.roundCornersAndDropShadow()
        three.roundCornersAndDropShadow()
        two.roundCornersAndDropShadow()
        one.roundCornersAndDropShadow()
        six.roundCornersAndDropShadow()
        five.roundCornersAndDropShadow()
        four.roundCornersAndDropShadow()
        nine.roundCornersAndDropShadow()
        eight.roundCornersAndDropShadow()
        seven.roundCornersAndDropShadow()
        changeSign.roundCornersAndDropShadow()
        nepero.roundCornersAndDropShadow()
        squareRoot.roundCornersAndDropShadow()
        pi.roundCornersAndDropShadow()
        squared.roundCornersAndDropShadow()
        cubic.roundCornersAndDropShadow()
        factorial.roundCornersAndDropShadow()
        invert.roundCornersAndDropShadow()
        resultLbl.layer.shadowColor = UIColor.black.cgColor
        resultLbl.layer.shadowOpacity = 0.7
        resultLbl.layer.shadowOffset = CGSize.zero
        resultLbl.layer.shadowRadius = 5
    }
}

extension String {
    struct Formatter {
        static let instance = NumberFormatter()
    }
    var doubleValue:Double? {
        return Formatter.instance.number(from: self)?.doubleValue
    }
    var integerValue:Int? {
        return Formatter.instance.number(from: self)?.intValue
    }
}
