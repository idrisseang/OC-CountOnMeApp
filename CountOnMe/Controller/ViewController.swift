//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    /// Allows to retrieve the elements present in the textView
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    /// Variable that links the model to the controller
    private var calculator = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Clears all content entered in the textView using the AC button
    @IBAction func tappedEraseButton(_ sender: Any) {
        self.textView.text = ""
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if self.calculator.expressionHaveResult(calculText: self.textView.text) {
            textView.text = ""
        }

        textView.text.append(numberText)
    }

    @IBAction func tappedOperandButton(_ sender: UIButton) {
        let (canAddOperator, message) = self.calculator.canAddOperator(elements: self.elements)
        if canAddOperator {
            if let operand = sender.currentTitle {
                textView.text.append(" \(operand) ")
            }
        } else {
            return self.createCustomAlert(message: message)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {

        let (isExpressionCorrect, errorMessage) = self.calculator.expressionIsCorrect(elements: self.elements)
        let (expressionHaveEnoughElements, error) = self.calculator.expressionHaveEnoughElement(elements: self.elements)

        guard isExpressionCorrect else {
            return self.createCustomAlert(message: errorMessage)
        }

        guard expressionHaveEnoughElements else {
            return self.createCustomAlert(message: error)
        }

        /// Get the array containing the result from the model and the error
        let (resultContainer, nilError) = self.calculator.calculate(elements: self.elements)
        /// Check if this result exists
        if let resultToDisplay = resultContainer?.first {
            textView.text.append(" = \(resultToDisplay)") /// If yes, add the result to the textView
        } else {
            self.handleDivisionByZero(nilError) /// Otherwise, handle division by zero
        }
    }

    private func createCustomAlert(message: String) {
        let alertVC = UIAlertController(title: "Oops ⚠️", message: "\(message).", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }

    private func handleDivisionByZero(_ message: String) {
        self.createCustomAlert(message: message)
        self.textView.text = "Error"
    }
}
