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

    func testGivenLeftOperandIs10_WhenAdding2_ThenResultShouldBe12() {

        let calculator = Calculator()

        let result = calculator.execute(with: .add, leftOperand: 10, rightOperand: 2)

        XCTAssertEqual(result, 12)
    }

}
