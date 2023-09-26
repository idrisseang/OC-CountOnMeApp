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

    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }

    private var calculator = Calculator()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard self.calculator.expressionIsCorrect(elements: self.elements) else {
    let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        guard self.calculator.expressionHaveEnoughElement(elements: self.elements) else {
        let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }

        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!

            let result = self.calculator.execute(
                with: Calculator.Operations(rawValue: operand)!,
                leftOperand: left,
                rightOperand: right)
            if result == nil {
                self.handleDivisionByZero()
                break
            } else {
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result!)", at: 0)
                textView.text.append(" = \(operationsToReduce.first!)")
            }
        }
    }

    private func handleDivisionByZero() {

        let alertVC = UIAlertController(title: "Erreur", message: "Opération impossible", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        self.textView.text = ""
    }
}
