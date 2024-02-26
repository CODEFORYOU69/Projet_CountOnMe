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
    
    var elements: [String] = []
    
    func addElement(_ element: String) {
        if isOperator(element) {
            elements.append(element)
        }
        else if Double(element) != nil {
            if var lastElement = elements.last {
               
                lastElement += "\(element)"
                elements[elements.count - 1] = lastElement
            } else {

                elements.append(element)
            }
        }
    }


    func isOperator(_ element: String) -> Bool {
        return ["+", "-", "*", "/"].contains(element)
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
    
  
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return !(elements.last == "+" || elements.last == "-" || elements.last == "/" || elements.last == "*")
    }
    
    var expressionHaveResult: Bool {
        return elements.contains("=")
    }
    
    var lastResult: String?
    
    func calculate() -> Result<String, CalculatorError> {
        print("Calculating with elements: \(elements)")

        
        guard expressionHaveEnoughElement else {
            print("Not enough elements")

            return .failure(.notEnoughElements)
        }
        
        var operationsToReduce = elements
        
        while let index = operationsToReduce.firstIndex(where: { $0 == "*" || $0 == "/" }) {
            let operand = operationsToReduce[index]
            guard let left = Double(operationsToReduce[index - 1]),
                  let right = Double(operationsToReduce[index + 1]) else {
                return .failure(.incorrectExpression)
            }
            
            let result: Double
            switch operand {
            case "*":
                result = left * right
            case "/":
                if right == 0 {
                    return .failure(.divisionByZero)
                }
                result = left / right
            default:
                return .failure(.other("Opérateur inconnu"))
            }
            
            operationsToReduce.replaceSubrange(index-1...index+1, with: [String(result)])
        }
        
        while operationsToReduce.count > 1 {
            guard let left = Double(operationsToReduce[0]),
                  let right = Double(operationsToReduce[2]) else {
                return .failure(.incorrectExpression)
            }
            let operand = operationsToReduce[1]
            
            let result: Double
            switch operand {
            case "+":
                result = left + right
            case "-":
                result = left - right
            default:
                return .failure(.other("No Calculable result"))
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert(String(result), at: 0)
        }
        
        if let result = operationsToReduce.first {
            lastResult = result
            return .success(result)
        } else {
            return .failure(.other("No Calculable result"))
        }
    }
}
extension Calculator.CalculatorError: Equatable {}
