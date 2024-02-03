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
    // Given: A calculator with an expression "2 + 3"
    // When: The calculate() method is called
    // Then: The result should be "5"
    func test_GivenCalculatorWithTwoPlusThree_WhenCalculateIsCalled_ShouldReturnFive() {
        // Given
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        
        // When
        let calculationResult = calculator.calculate()
        
        // Then
        switch calculationResult {
        case .success(let result):
            XCTAssertEqual(result, "5", "The result of 2 + 3 should be 5")
        case .failure(let error):
            XCTFail("Calculation failed with error: \(error)")
        }
    }
    // Test: sub two numbers
    // Given: A calculator with an expression "7 - 5"
    // When: The calculate() method is called
    // Then: The result should be "2"
    func test_GivenCalculatorWithTwoMinusThree_WhenCalculateIsCalled_ShouldReturnTwo() {
        // Given
        calculator.addElement("7")
        calculator.addElement("-")
        calculator.addElement("5")
        
        // When
        let calculationResult = calculator.calculate()
        
        // Then
        switch calculationResult {
        case .success(let result):
            XCTAssertEqual(result, "2", "The result of 7 - 5 should be 2")
        case .failure(let error):
            XCTFail("Calculation failed with error: \(error)")
        }
    }

    // Test: Preventing division by zero
    // Given: A calculator with an expression "5 / 0"
    // When: The calculate() method is called
    // Then: The calculation should fail or return nil
    func test_GivenCalculatorWithFiveDividedByZero_WhenCalculateIsCalled_ShouldFailOrReturnNil() {
        // Given
        calculator.addElement("5")
        calculator.addElement("/")
        calculator.addElement("0")
        
        // When
        let calculationResult = calculator.calculate()
            
            // Then
            switch calculationResult {
            case .success(_):
                XCTFail("The calculation should not succeed when dividing by zero.")
            case .failure(let error):
                XCTAssertEqual(error, Calculator.CalculatorError.divisionByZero, "Dividing by zero should result in a divisionByZero error.")
            }
    }
    // Test: Respecting operator precedence
    // Given: A calculator with an expression "2 + 3 * 4"
    // When: The calculate() method is called
    // Then: The result should be "14"
    func test_GivenCalculatorWithTwoPlusThreeTimesFour_WhenCalculateIsCalled_ShouldReturnFourteen() {
        // Given
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        calculator.addElement("*")
        calculator.addElement("4")
        
        // When
        let calculationResult = calculator.calculate()
        
        // Then
        switch calculationResult {
        case .success(let result):
            XCTAssertEqual(result, "14", "The result of 2 + 3 * 4 should be 14")
        case .failure(let error):
            XCTFail("Calculation failed with error: \(error)")
        }
    }

    // Test: Resetting the calculator
    // Given: A calculator after performing a calculation
    // When: The clear() method is called
    // Then: The calculator should be reset
    func test_GivenCalculatorAfterCalculation_WhenClearIsCalled_ShouldResetCalculator() {
        // Given
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        _ = calculator.calculate()
        
        
        
        // When
        calculator.clear()
        
        // Then
        XCTAssertTrue(calculator.elements.isEmpty, "The calculator should be reset")
        XCTAssertNil(calculator.lastResult, "The last result should be reset")
    }

    func test_ClearingCalculator_ShouldResetItsState() {
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        calculator.clear()
        XCTAssertTrue(calculator.elements.isEmpty, "La méthode clear() devrait réinitialiser l'état de la calculatrice")
        XCTAssertNil(calculator.lastResult, "La méthode clear() devrait réinitialiser le dernier résultat")
    }
    
    

}


