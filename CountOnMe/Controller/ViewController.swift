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
        if self.calculator.canAddOperator(elements: self.elements) {
            if let operand = sender.currentTitle {
                textView.text.append(" \(operand) ")
            }
        } else {
            return self.createCustomAlert(title: "Oops", message: "An operator is already placed")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard self.calculator.expressionIsCorrect(elements: self.elements) else {
            return self.createCustomAlert(title: "Oops", message: "Enter a correct expression")
        }

        guard self.calculator.expressionHaveEnoughElement(elements: self.elements) else {
            return self.createCustomAlert(title: "Oops", message: "Start a new calculation")
        }

        /// Get the array containing the result from the model
        let operationsToReduce = self.calculator.calculate(elements: self.elements)
        /// Check if this result exists
        if let resultToDisplay = operationsToReduce?.first {
            textView.text.append(" = \(resultToDisplay)") /// If yes, add the result to the textView
        } else {
            self.handleDivisionByZero() /// Otherwise, handle division by zero
        }
    }

    private func createCustomAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: "\(title) ⚠️", message: "\(message).", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }

    private func handleDivisionByZero() {
        self.createCustomAlert(title: "Error", message: "Operation not possible")
        self.textView.text = "Error"
    }
}
