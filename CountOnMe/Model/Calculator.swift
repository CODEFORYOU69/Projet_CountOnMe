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
        case notEnoughElements
        case divisionByZero
    }
    
    var elements: [String] = []
    
    func addElement(_ element: String) {
        if isOperator(element) {
            elements.append(element)
        }
        else if let number = Double(element) {
            if var lastElement = elements.last, let lastNumber = Double(lastElement) {
               
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
    
    var lastResult: String?
    
    func calculate() -> Result<String, CalculatorError> {
        guard expressionHaveEnoughElement else {
            print("Not enough elements")
            return .failure(.notEnoughElements)
        }
        
        var operationsToReduce = elements
        
        // Gestion des multiplications et divisions
        while let index = operationsToReduce.firstIndex(where: { $0 == "*" || $0 == "/" }) {
            let operand = operationsToReduce[index]
            if let left = Double(operationsToReduce[index - 1]),
               let right = Double(operationsToReduce[index + 1]) {
                let result: Double = operand == "*" ? left * right : (right == 0 ? Double.nan : left / right)
                if result.isNaN { // Vérifie si le résultat est NaN, ce qui indiquerait une division par zéro
                    return .failure(.divisionByZero)
                }
                operationsToReduce.replaceSubrange(index-1...index+1, with: [String(result)])
            }
        }
        
        // Gestion des additions et soustractions
        while operationsToReduce.count > 1 {
            if let index = operationsToReduce.firstIndex(where: { $0 == "+" || $0 == "-" }) {
                let operand = operationsToReduce[index]
                if let left = Double(operationsToReduce[index - 1]),
                   let right = Double(operationsToReduce[index + 1]) {
                    let result: Double = operand == "+" ? left + right : left - right
                    operationsToReduce.replaceSubrange(index-1...index+1, with: [String(result)])
                }
            } 
        }
        
        if let result = operationsToReduce.first, let finalResult = Double(result) {
            lastResult = String(finalResult)
            return .success(String(finalResult))
        }
        return .success("Default Value") // Remplacez "Default Value" par ce que vous jugez approprié
        
    }
}
extension Calculator.CalculatorError: Equatable {}
