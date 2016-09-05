//
//  CalculatorBrain.swift
//  StanfordCalculator
//
//  Created by Fabio Cipriani on 03/09/16.
//  Copyright © 2016 Fabio Cipriani. All rights reserved.
//

import Foundation

func factorial(op: Double) -> Double {
    
    if op<=1 {
        return 1
    }
    return op * factorial(op: op-1.0)
}


class CalculatorBrain {
    
    private var accumulator = 0.0
    var description = ""
    var isPartialResult: Bool {
        get {
            if pending != nil {
                return true
            } else {
                return false
            }
        }
    }
    var result: Double {
        get {
            return accumulator
        }
    }
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var operations: Dictionary<String, Operation> = [
        "x²" : Operation.UnaryOperation({$0*$0}),
        "x³" : Operation.UnaryOperation({pow($0, 3)}) ,
        "x!" : Operation.UnaryOperation({factorial(op: $0)}),
        "1/x" : Operation.UnaryOperation({1/$0}),
        "π" : Operation.Constant(M_PI),
        "ℯ" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation({sqrt($0)}),
        "cos": Operation.UnaryOperation({cos($0)}),
        "±" : Operation.UnaryOperation({
            if($0 != 0.0) {return -$0} else {return 0.0}
        }),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "=" : Operation.Equals,
        "C" : Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        resetHistory()
    }
    
    func updateHistory(string: String) {
        description += string
    }
    
    func resetHistory() {
        description = ""
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
            
        }
    }
}

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
