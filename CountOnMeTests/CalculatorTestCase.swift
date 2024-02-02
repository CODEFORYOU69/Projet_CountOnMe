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
            calculator = Calculator() // Initialisation de l'instance de Calculator
        }

        override func tearDownWithError() throws {
            calculator = nil // Nettoyage de l'instance pour éviter les fuites de mémoire
            try super.tearDownWithError()
        }


    func test_AddingTwoNumbers_ShouldReturnSum() {
        let calculator = Calculator()
        calculator.addElement("2")
        calculator.addElement("+")
        calculator.addElement("3")
        let result = calculator.calculate()
        XCTAssertEqual(result, "5", "Le résultat de 2 + 3 devrait être 5")
    }
    func testCalculationError() {
        calculator.addElement("2")
        calculator.addElement("/")
        calculator.addElement("0") // Division par zéro, par exemple
        let result = calculator.calculate()
        XCTAssertNil(result, "Le résultat devrait être nil en cas de division par zéro")
    }
}
