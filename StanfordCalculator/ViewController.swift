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
    
    // MARK: @IBOutlets
    @IBOutlet private weak var btn: Button!
    @IBOutlet private weak var resultLbl: UILabel!
    @IBOutlet private weak var historyLbl: UILabel!
    @IBOutlet private weak var invert: Button!
    @IBOutlet private weak var factorial: Button!
    @IBOutlet private weak var cubic: Button!
    @IBOutlet private weak var squared: Button!
    @IBOutlet private weak var comma: Button!
    @IBOutlet private weak var equals: Button!
    @IBOutlet private weak var zero: Button!
    @IBOutlet private weak var three: Button!
    @IBOutlet private weak var two: Button!
    @IBOutlet private weak var one: Button!
    @IBOutlet private weak var six: Button!
    @IBOutlet private weak var five: Button!
    @IBOutlet private weak var four: Button!
    @IBOutlet private weak var nine: Button!
    @IBOutlet private weak var eight: Button!
    @IBOutlet private weak var seven: Button!
    @IBOutlet private weak var changeSign: Button!
    @IBOutlet private weak var nepero: Button!
    @IBOutlet private weak var squareRoot: Button!
    @IBOutlet private weak var pi: Button!
    @IBOutlet private weak var multiply: Button!
    @IBOutlet private weak var divide: Button!
    @IBOutlet private weak var minus: Button!
    @IBOutlet private weak var plus: Button!
    
    // MARK: Private properties
    private var userInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    // MARK: Properties
    var displayValue: Double? {
        get {
            if let value = resultLbl.text!.doubleValue {
                return value
            } else if let value2 = resultLbl.text!.replacingOccurrences(of: ".", with: ",").doubleValue{
                return value2
            } else {
                return nil
            }
        } set {
            if newValue != nil {
                let newValueStr = String(describing: newValue!)
                if checkIfValueIsInteger(value: newValue){
                    resultLbl.text = newValueStr.replacingOccurrences(of: ".0", with: "")
                } else {
                    resultLbl.text = newValueStr
                }
            } else {
                resultLbl.text = "0"
            }
        }
    }
    
    // MARK: UI setup
    override func viewDidLoad() {
        updateUIElementsAppearance()
    }
    
    // MARK: @IBActions
    @IBAction private func backspacePressed() {
        if userInTheMiddleOfTyping {
            var str = "\(resultLbl.text!)"
            if str.characters.count>1 {
                str = String(str.characters.dropLast())
                if str.doubleValue != nil {
                    displayValue! = str.doubleValue!
                } else if str.replacingOccurrences(of: ".", with: ",").doubleValue != nil {
                    displayValue! = str.doubleValue!
                }
            } else {
                clearHistory()
            }
        }
    }
    
    @IBAction private func commaPressed(_ sender: Button) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            if !resultLbl.text!.contains(digit) {
                appendDigit(digit)
            }
        } else {
            resultLbl.text = "0."
        }
        userInTheMiddleOfTyping = true
    }
    
    @IBAction private func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            appendDigit(digit)
        } else {
            resultLbl.text = digit
        }
        userInTheMiddleOfTyping = true
    }
    
    @IBAction private func operationBtnPressed(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue!)
            userInTheMiddleOfTyping = false
        }
        if let mathSym = sender.currentTitle {
            brain.performOperation(symbol: mathSym)
        }
        roundResult(result: "\(brain.result)")
    }
    
    // MARK: Functions
    private func appendDigit(_ digit: String) {
        let textCurrentlyInDisplay = resultLbl.text!
        resultLbl.text = textCurrentlyInDisplay + digit
    }
    
    private func clearHistory() {
        displayValue = 0.0
        historyLbl.text = "History"
        userInTheMiddleOfTyping = false
    }
    
    private func roundResult(result: String) {
        if let y = result.doubleValue?.roundToPlaces(places: 6) {
            displayValue = y
        } else if let x = result.replacingOccurrences(of: ".", with: ",").doubleValue?.roundToPlaces(places: 6) {
            displayValue = x
        }
    }
    
    private func checkIfValueIsInteger(value: Double?) -> Bool{
        let str = String(describing: value!).substring(from: String(describing: value!).index(String(describing: value!).endIndex, offsetBy: -2))
        if str == ".0" {
            return true
        }
        return false
    }
    
    private func updateUIElementsAppearance() {
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

// MARK: String Extension
private extension String {
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
