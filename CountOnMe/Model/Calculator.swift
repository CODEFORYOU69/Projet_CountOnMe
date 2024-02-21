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
        // Vérifie si "-" est utilisé dans le contexte d'un nombre négatif ou comme opérateur
        if element == "-" {
            if canAddNegativeNumberIndicator() {
                // Gère le "-" comme l'indicateur d'un nombre négatif
                handleNegativeNumberIndicator()
            } else if canAddSub() {
                // Ajoute "-" comme un opérateur de soustraction
                elements.append(element)
            }
        } else if ["+", "*", "/"].contains(element) {
            if canAddSub() {
                elements.append(element)
            }
        } else if let number = Double(element) {
            handleNumber(element, number: number)
        }
    }

    func canAddSub() -> Bool {
        // Un opérateur peut être ajouté si le dernier élément n'est pas un opérateur
        // ou si le dernier élément est "-" et qu'il y a des éléments précédents qui permettent un opérateur
        if let lastElement = elements.last {
            return !isOperator(lastElement) || (lastElement == "-" && elements.count > 1)
        }
        return true
    }

    func canAddNegativeNumberIndicator() -> Bool {
        // "-" peut être ajouté comme indicateur de nombre négatif si c'est le premier élément
        // ou si le dernier élément est un opérateur (sauf si le dernier est déjà un "-")
        return elements.isEmpty || (isOperator(elements.last!) && elements.last != "-")
    }

    func handleNegativeNumberIndicator() {
        // Ajoute "-" en tant qu'indicateur de nombre négatif
        elements.append("-")
    }

    func handleNumber(_ element: String, number: Double) {
        // Si le dernier élément est "-", combine le "-" avec le nombre pour former un nombre négatif
        if let lastElement = elements.last, lastElement == "-" {
            elements[elements.count - 1] += element
        } else {
            elements.append(element)
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
        return !(elements.last == "+" || elements.last == "-" || elements.last == "/" || elements.last == "*" )
    }
    
    var expressionHaveResult: Bool {
        return elements.contains("=")
    }
    
    var lastResult: String?
    
    func calculate() -> Result<String, CalculatorError> {

        
        
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
                return .failure(.other("Opérateur inconnu"))
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert(String(result), at: 0)
        }
        
        if let result = operationsToReduce.first {
            lastResult = result
            return .success(result)
        } else {
            return .failure(.other("Aucun résultat calculable"))
        }
    }
}
extension Calculator.CalculatorError: Equatable {}
