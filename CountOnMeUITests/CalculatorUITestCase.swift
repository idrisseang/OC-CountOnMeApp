//
//  CalculatorUITestCase.swift
//  CountOnMeUITests
//
//  Created by Idrisse Angama on 28/09/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest

final class CalculatorUITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// Test the tap on all the number buttons

    func testUI_WhenClikingOnButtons_ThenTextShouldBeAppearInTextView() {
        for buttonNumber in 0...9 {
            app.buttons["\(buttonNumber)"].tap()
        }

        let appTextView = app.textViews["textView"]

        XCTAssertEqual(appTextView.value as? String, "0123456789")
    }
}
