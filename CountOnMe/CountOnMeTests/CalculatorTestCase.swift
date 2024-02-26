//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by younes ouasmi on 02/02/2024.
//  Copyright © 2024 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorTestCase: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        calculator = Calculator()
    }
    
    override func tearDownWithError() throws {
        calculator = nil
        try super.tearDownWithError()
    }
    
    // Test: Adding two numbers
    func testAdditionOfTwoNumbers() {
        // Given
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("5.0"), "The result of 2 + 3 should be 5")
    }
    
    // Test: Subtracting two numbers
    func testSubtractionOfTwoNumbers() {
        // Given
        calculator.addElement("7")
        calculator.addElement("-")
        calculator.addElement("5")
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("2.0"), "The result of 7 - 5 should be 2")
    }
    
    // Test: Multiplication of two numbers
    func testMultiplicationOfTwoNumbers() {
        // Given
        calculator.addElement("3")
        calculator.addElement("*")
        calculator.addElement("4")
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("12.0"), "The result of 3 * 4 should be 12")
    }
    
    // Test: Division of two numbers
    func testDivisionOfTwoNumbers() {
        // Given
        calculator.addElement("6")
        calculator.addElement("/")
        calculator.addElement("3")
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("2.0"), "The result of 6 / 3 should be 2")
    }
    
    // Test: Preventing division by zero
    func testPreventingDivisionByZero() {
        // Given
        calculator.addElement("5")
        calculator.addElement("/")
        calculator.addElement("0")
        
        // When
        let result = calculator.calculate()
        
        // Then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .divisionByZero, "Should return division by zero error")
        default:
            XCTFail("Expected division by zero error")
        }
    }
    
    // Test: Clearing the calculator
    func testClearingCalculator() {
        // Given
        calculator.addElement("5")
        calculator.addElement("+")
        calculator.addElement("2")
        _ = calculator.calculate()
        
        // When
        calculator.clear()
        
        // Then
        XCTAssertTrue(calculator.elements.isEmpty, "Calculator should be cleared")
        XCTAssertNil(calculator.lastResult, "Last result should be cleared")
    }
    
    
    // Test: Expression ends with an operator
    func testExpressionEndsWithAnOperator() {
        // Given
        calculator.addElement("5")
        calculator.addElement("+")
        
        // When
        let result = calculator.calculate()
        
        // Then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .notEnoughElements, "Should return not enought elements error")
        default:
            XCTFail("Expected not enought elements error")
        }
    }
    // Test: Checking operator precedence with addition and multiplication
    func testOperatorPrecedenceWithAdditionAndMultiplication() {
        // Given
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        calculator.addElement("*")
        calculator.addElement("4") // 2 + 3 * 4 = 14
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("14.0"), "The result of 2 + 3 * 4 should be 14 due to operator precedence")
    }

    // Test: Checking operator precedence with addition and division
    func testOperatorPrecedenceWithAdditionAndDivision() {
        // Given
        calculator.addElement("10")
        calculator.addElement("+")
        calculator.addElement("2")
        calculator.addElement("/")
        calculator.addElement("2") // 10 + 2 / 2 = 11
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("11.0"), "The result of 10 + 2 / 2 should be 11 due to operator precedence")
    }

    // Test: Checking operator precedence with multiple operations
    func testOperatorPrecedenceWithMultipleOperations() {
        // Given
        calculator.addElement("10")
        calculator.addElement("-")
        calculator.addElement("2")
        calculator.addElement("*")
        calculator.addElement("3")
        calculator.addElement("+")
        calculator.addElement("5")
        calculator.addElement("/")
        calculator.addElement("2") // 10 - 2 * 3 + 5 / 2 = 4
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("6.5"), "The result of 10 - 2 * 3 + 5 / 2 should be 4 due to operator precedence")
    }
    // Test: Using the result of a previous calculation in a new calculation
    func testUsingPreviousResultInNewCalculation() {
        // Given
        calculator.addElement("5")
        calculator.addElement("+")
        calculator.addElement("3") // 5 + 3 = 8
        
        // Perform the first calculation
        var result = calculator.calculate()
        
        // Then
        switch result {
        case .success(let output):
            XCTAssertEqual(output, "8.0", "The result of 5 + 3 should be 8.")
        case .failure(let error):
            XCTFail("First calculation failed with error: \(error)")
        }

        // Now use the result in a new calculation: 8 * 2 = 16
        if let lastResult = calculator.lastResult {
            calculator.clear() // Clearing the calculator for a new expression
            calculator.addElement(lastResult) // Using the result of the previous calculation
            calculator.addElement("*")
            calculator.addElement("2")
            
            // Perform the new calculation
            result = calculator.calculate()
            
            // Then
            switch result {
            case .success(let newOutput):
                XCTAssertEqual(newOutput, "16.0", "The result of 8 * 2 should be 16.")
            case .failure(let newError):
                XCTFail("Second calculation failed with error: \(newError)")
            }
        } else {
            XCTFail("No result from first calculation to use in second calculation")
        }
    }


}
