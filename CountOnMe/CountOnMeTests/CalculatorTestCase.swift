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
        calculator.addElement("203")
        calculator.addElement("+")
        calculator.addElement("33")
        
        // When
        let result = calculator.calculate()
        
        // Then
        XCTAssertEqual(result, .success("236.0"), "The result of 203 + 33 should be 236")
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
    func testRemoveLastElement_WhenElementsNotEmpty_ShouldRemoveLast() {
        // Given
        calculator.addElement("3")
        calculator.addElement("+")
        calculator.addElement("5")
        
        // Precondition check (Optional but recommended for clarity)
        XCTAssertEqual(calculator.elements, ["3", "+", "5"], "Initial elements should be 3, +, and 5")
        
        // When
        calculator.removeLastElement()
        
        // Then
        XCTAssertEqual(calculator.elements, ["3", "+"], "The last element should be removed, leaving 3 and +")
    }
    
    func testRemoveLastElement_WhenElementsIsEmpty_ShouldDoNothing() {
        // Given
        // No elements are added to the calculator
        
        // When
        calculator.removeLastElement()
        
        // Then
        XCTAssertTrue(calculator.elements.isEmpty, "Elements should still be empty after removing last element")
    }
    func testCurrentExpression_WhenElementsContainsMultipleItems_ShouldReturnCorrectExpression() {
        // Given
        calculator.addElement("3")
        calculator.addElement("+")
        calculator.addElement("5")

        // When
        let expression = calculator.currentExpression

        // Then
        XCTAssertEqual(expression, "3 + 5", "The current expression should be '3 + 5'")
    }

    func testCurrentExpression_WhenElementsIsEmpty_ShouldReturnEmptyString() {
        // Given
        // No elements are added to the calculator

        // When
        let expression = calculator.currentExpression

        // Then
        XCTAssertTrue(expression.isEmpty, "The current expression should be an empty string when no elements are added")
    }
    func testCanAddOperator_WhenLastElementIsNumber_ShouldReturnTrue() {
        // Given
        calculator.addElement("3")

        // When
        let canAdd = calculator.canAddOperator

        // Then
        XCTAssertTrue(canAdd, "Should be able to add an operator after a number")
    }

    func testCanAddOperator_WhenLastElementIsOperator_ShouldReturnFalse() {
        // Given scenarios for each operator
        let operators = ["+", "-", "*", "/"]

        operators.forEach { operatorSymbol in
            calculator.clear() // Make sure calculator is clear before each test
            calculator.addElement("3") // Add a number before the operator for valid syntax
            calculator.addElement(operatorSymbol) // Add the operator

            // When
            let canAdd = calculator.canAddOperator

            // Then
            XCTAssertFalse(canAdd, "Should not be able to add an operator after another operator")
        }
    }

    func testCanAddOperator_WhenElementsIsEmpty_ShouldReturnTrue() {
        // Given
        // No elements are added to the calculator

        // When
        let canAdd = calculator.canAddOperator

        // Then
        XCTAssertTrue(canAdd, "Should be able to add an operator if no elements are present")
    }
    func testCalculate_WhenNonNumericElementsPresent_ShouldReturnInvalidNumberError() {
        // Given: an expression with a non-numeric element
        calculator.addElement("5")
        calculator.addElement("*")
        calculator.addElement("three")

        // When: calculating the result
        let result = calculator.calculate()

        // Then: expect a failure due to invalid number
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .notEnoughElements, "Should return notEnoughElements error due to non-numeric element")
        default:
            XCTFail("Expected failure with notEnoughElements error")
        }
    }
    func testCalculate_WhenUnknownOperatorPresent_ShouldReturnUnknownOperatorError() {
        // Given: an expression with an unknown operator
        calculator.addElement("5")
        calculator.addElement("?")
        calculator.addElement("2")

        // When: calculating the result
        let result = calculator.calculate()

        // Then: expect a failure due to unknown operator
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .notEnoughElements, "Should return notEnoughElements error due to 'Opérateur inconnu'")
        default:
            XCTFail("Expected failure with other error indicating unknown operator")
        }
    }
    func testCalculate_WhenNonCalculableExpression_ShouldReturnNoCalculableResultError() {
        // Given: a correct expression that somehow leads to a non-calculable state
        calculator.addElement("5")
        calculator.addElement("+")
        // You might need to simulate a scenario that leads to a non-calculable result,
        // which might be tricky if your code doesn't naturally allow it.
        // This is more of a placeholder for situations where your logic might have gaps.

        // When: calculating the result
        let result = calculator.calculate()

        // Then: expect a failure indicating no calculable result
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .notEnoughElements, "Should return notEnoughElements error due to 'No Calculable result'")
        default:
            XCTFail("Expected failure with other error indicating no calculable result")
        }
    }


    
}
