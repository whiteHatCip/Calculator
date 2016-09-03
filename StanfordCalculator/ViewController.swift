//
//  ViewController.swift
//  StanfordCalculator
//
//  Created by Fabio Cipriani on 03/09/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var btn: UIButton!
    @IBOutlet private weak var resultLbl: UILabel!
    @IBOutlet weak var historyLbl: UILabel!
    
    private var userInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            if sender.currentTitle! == "."{
                if !resultLbl.text!.contains(".") {
                    appendDigit(digit)
                }
            } else {
                appendDigit(digit)
            }
        } else {
            resultLbl.text = digit
        }
        userInTheMiddleOfTyping = true
    }
    
    func appendDigit(_ digit: String) {
        let textCurrentlyInDisplay = resultLbl.text!
        resultLbl.text = textCurrentlyInDisplay + digit
    }
    
    var displayValue: Double {
        get {
            return Double(resultLbl.text!)!
        } set {
            resultLbl.text = String(newValue)
        }
    }
    
    @IBAction func operationBtnPressed(_ sender: UIButton) {
        if resultLbl.text != "." {
            if userInTheMiddleOfTyping {
                brain.setOperand(operand: displayValue)
                userInTheMiddleOfTyping = false
            }
            if let mathSym = sender.currentTitle {
                brain.performOperation(symbol: mathSym)
            }
            displayValue = brain.result
        } else {
            brain.performOperation(symbol: "C")
            displayValue = 0.0
            historyLbl.text = "History"
            print(brain.description)
        }
    }
}
