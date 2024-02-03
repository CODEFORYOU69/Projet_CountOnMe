//
//  Calculator.swift
//  CountOnMe
//
//  Created by younes ouasmi on 01/02/2024.
//  Copyright © 2024 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {
    
    enum CalculatorError: Error {
        case incorrectExpression
        case notEnoughElements
        case divisionByZero
        case other(String)
    }
    
    // Stores elements of the expression (numbers and operators)
    var elements: [String] = []
    
    // Adds a new number or operator to the expression
    func addElement(_ element: String) {
        if let lastElement = elements.last, let _ = Double(lastElement), let _ = Double(element) {
            
            elements[elements.count - 1] = lastElement + element
        } else {
            elements.append(element)
        }
    }
    
    func clear() {
        elements.removeAll()
        lastResult = nil
    }
    func removeLastElement() {
        if !elements.isEmpty {
            elements.removeLast()
        }
    }
    
    var currentExpression: String {
        return elements.joined(separator: " ")
    }
    
    
    // Checks if the expression is correct
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    // Checks if the expression has enough elements for a valid calculation
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    // Checks if an operator can be added to the expression
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    var expressionHaveResult: Bool {
        return elements.contains("=")
    }
    
    var lastResult: String?
    
    
    // Performs the calculation and returns the result
    func calculate() -> Result<String, CalculatorError> {
        guard expressionIsCorrect else {
            return .failure(.incorrectExpression)
        }
        
        guard expressionHaveEnoughElement else {
            return .failure(.notEnoughElements)
        }
        
        
        var operationsToReduce = elements
        
        while operationsToReduce.contains("*") || operationsToReduce.contains("/") {
            if let index = operationsToReduce.firstIndex(where: { $0 == "*" || $0 == "/" }) {
                let left = Int(operationsToReduce[index - 1])!
                let operand = operationsToReduce[index]
                let right = Int(operationsToReduce[index + 1])!
                
                if operand == "/" && right == 0 {
                    return .failure(.divisionByZero)
                }
                
                let result: Int
                switch operand {
                case "*": result = left * right
                case "/": result = left / right
                default: fatalError("Unknown operator!")
                }
                
                operationsToReduce.replaceSubrange(index-1...index+1, with: ["\(result)"])
            }
        }
        
        
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator!")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        if let result = operationsToReduce.first {
            lastResult = result
            return .success("\(result)")
        } else {
            return .failure(.other("no possible result"))
        }
    }
    
}

extension Calculator.CalculatorError: Equatable {
    
}

