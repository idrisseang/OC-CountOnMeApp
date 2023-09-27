//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Idrisse Angama on 26/09/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorTestCase: XCTestCase {
    var calculator: Calculator!
    var elements = [String]()

    override func setUp() {
        self.calculator = Calculator()
    }

    func testGivenLeftOperandIs10_WhenAdding2_ThenResultShouldBe12() {

        let result = calculator.execute(with: .add, leftOperand: 10, rightOperand: 2)

        XCTAssertEqual(result, 12)
    }

    func testGivenLeftOperandIs10_WhenSubtracting2_ThenResultShouldBe8() {

        let result = calculator.execute(with: .subtract, leftOperand: 10, rightOperand: 2)

        XCTAssertEqual(result, 8)
    }

    func testGivenLeftOperandIs10_WhenMultiplyingBy5_ThenResultShouldBe50() {

        let result = calculator.execute(
            with: .multiply,
            leftOperand: 10,
            rightOperand: 5)

        XCTAssertEqual(result, 50)
    }

    func testGivenLeftOperandIs10_WhenDividingBy2_ThenResultShouldBe5() {

        let result = calculator.execute(
            with: .divide,
            leftOperand: 10,
            rightOperand: 2)

        XCTAssertEqual(result, 5)
    }

    /// Test division by zero

    func testGivenLeftOperandIs10_WhenDividingByZero_ThenResultShouldBeNil() {

        let result = calculator.execute(with: .divide, leftOperand: 10, rightOperand: 0)

        XCTAssertNil(result)
    }

    /// Test if an expression is not correct

    func testGivenLastElementIsPlus_WhenCheckingIfExpressionIsCorrect_ThenResultShouldBeFalse() {

        self.elements = ["5", "0", "+"]

        XCTAssertFalse(calculator.expressionIsCorrect(elements: elements))
    }

    /// Test if an expression is correct

    func testGivenExpressionIsCorrect_WhenCheckingIfExpressionIsCorrect_ThenShouldBeTrue() {

        self.elements = ["5", "+", "0"]

        XCTAssertTrue(calculator.expressionIsCorrect(elements: elements))
    }

    /// Test if an expression has enough elements

    func testGivenExpressionContains2Elements_WhenCheckingIfEnoughElements_ThenShouldBeFalse() {

        self.elements = ["2", "5"]

        XCTAssertFalse(calculator.expressionHaveEnoughElement(elements: elements))
    }

    func testGivenExpressionContains3Elements_WhenCheckingIfEnoughElements_ThenShouldBeTrue() {

        self.elements = ["2", "+", "5"]

        XCTAssertTrue(calculator.expressionHaveEnoughElement(elements: elements))
    }

    /// Test an expression with random numbers

    func testGivenOperandsAreRandom_WhenAddingThem_ThenResultShouldBeGood() {

        let leftOperand = Int.random(in: 0...20)
        let rightOperand = Int.random(in: 0...10)

        let resultat = leftOperand + rightOperand
        let result = calculator.execute(with: .add, leftOperand: leftOperand, rightOperand: rightOperand)

        XCTAssertEqual(result, resultat)
    }

}
