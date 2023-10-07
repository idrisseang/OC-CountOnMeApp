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

    // TEST SIMPLE CALCULATIONS WITHOUT PRIORITIES

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

        let (expressionIsCorrect, _) = calculator.expressionIsCorrect(elements: elements)

        XCTAssertFalse(expressionIsCorrect)
    }

    /// Test if an expression is correct

    func testGivenExpressionIsCorrect_WhenCheckingIfExpressionIsCorrect_ThenShouldBeTrue() {

        self.elements = ["5", "+", "0"]

        let (expressionIsCorrect, _) = calculator.expressionIsCorrect(elements: elements)

        XCTAssertTrue(expressionIsCorrect)
    }

    /// Test if an expression has enough elements

    func testGivenExpressionContains2Elements_WhenCheckingIfEnoughElements_ThenShouldBeFalse() {

        self.elements = ["2", "5"]

        let (expressionHasEnoughElement, _) = calculator.expressionHaveEnoughElement(elements: self.elements)

        XCTAssertFalse(expressionHasEnoughElement)
    }

    func testGivenExpressionContains3Elements_WhenCheckingIfEnoughElements_ThenShouldBeTrue() {

        self.elements = ["2", "+", "5"]

        let (expressionHasEnoughElement, _) = calculator.expressionIsCorrect(elements: elements)

        XCTAssertTrue(expressionHasEnoughElement)
    }

    /// Test an expression with random numbers

    func testGivenOperandsAreRandom_WhenAddingThem_ThenResultShouldBeGood() {

        let leftOperand = Double.random(in: 0...20)
        let rightOperand = Double.random(in: 0...10)

        let resultat = leftOperand + rightOperand
        let result = calculator.execute(with: .add, leftOperand: leftOperand, rightOperand: rightOperand)

        XCTAssertEqual(result, resultat)
    }

    /// Test a division with a decimal result
    func testGivenOperandsAre5And2_ByDividing5By2_ThenResultShouldBe2Point50() {

        let result = calculator.execute(with: .divide, leftOperand: 5, rightOperand: 2)
        guard let result else {
            return
        }
        XCTAssertEqual(calculator.roundResult(result), "2.50")
    }

    /// Test if we can add an operator in expression

    func testCheckIfWeCanAddAnOperator() {

        self.elements = ["24", "+"]

        let (canAddAnOperator, _) = self.calculator.canAddOperator(elements: self.elements)

        XCTAssertFalse(canAddAnOperator)

    }

    /// Tests expressions with priorities

    func testGivenElementsContainsPriorities_WhenTestingCalculate_ThenResultShouldBeRight() {

        self.elements = ["5", "*", "5", "+", "10", "÷", "2", "*", "8", "-", "2"]

        let (resultContainer, _) = calculator.calculate(elements: self.elements)
        let result = resultContainer?.first!

        if let result {
            XCTAssertEqual(result, "63")
        }
    }

    func testGivenElementsAre5Times8DividedBy25_WhenTestingCalculateFunc_ThenResultShouldBeRight() {

        self.elements = ["5", "*", "8", "÷", "25"]

        let (resultContainer, _) = calculator.calculate(elements: self.elements)
        let result = resultContainer?.first!

        if let result {
            XCTAssertEqual(result, "1.60")
        }
    }

    func testNilResultWithCalculate() {

        self.elements = ["4", "÷", "0"]

        let (resultContainer, _) = calculator.calculate(elements: self.elements)

        XCTAssertEqual(resultContainer?.first!, nil)
    }

    func testOperandIsNil() {
        self.elements = ["15", "5", "3"]

        let result = calculator.calculate(elements: self.elements)

        XCTAssertTrue(result == ([], ""))
    }

    func testCalculationWithInsaneNumbers() {

        self.elements = ["999999999999", "*", "999999999999"]

        let (resultContainer, _) = calculator.calculate(elements: self.elements)
        let result = resultContainer?.first!

        XCTAssertEqual(result, "9.99999999998e+23")
    }

}
