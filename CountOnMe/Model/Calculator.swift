//
//  Calculator.swift
//  CountOnMe
//
//  Created by Idrisse Angama on 26/09/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {

    // Error check computed variables
    func expressionIsCorrect(elements: [String] ) -> Bool {
        return Operations.allCases.allSatisfy { elements.last != $0.rawValue }
    }

    func expressionHaveEnoughElement(elements: [String] ) -> Bool {
        return elements.count >= 3
    }

    func canAddOperator(elements: [String] ) -> Bool {
        return Operations.allCases.allSatisfy { elements.last != $0.rawValue }
    }

    func expressionHaveResult(calculText: String) -> Bool {
        return calculText.firstIndex(of: "=") != nil
    }

    enum Operations: String, CaseIterable {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "÷"
    }

    func execute(with operation: Calculator.Operations, leftOperand: Double, rightOperand: Double) -> Double? {
        switch operation {
        case .add:
            return leftOperand + rightOperand
        case .subtract:
            return leftOperand - rightOperand
        case .multiply:
            return leftOperand * rightOperand
        case .divide:
            if rightOperand == 0 {
                return nil
            } else {
                return (leftOperand / rightOperand)
            }
        }
    }

    private func setUpCalculPriorities(elements: [String]) {
        var itemIndex = 0
        var operationsToReduce = elements

        while itemIndex < operationsToReduce.count {
            if operationsToReduce[itemIndex] == "*" || operationsToReduce[itemIndex] == "÷" {
                let numberToInsert = execute(
                    with: Calculator.Operations(rawValue: operationsToReduce[itemIndex])!,
                    leftOperand: Double(operationsToReduce[itemIndex - 1])!,
                    rightOperand: Double(operationsToReduce [itemIndex + 1])!)

                operationsToReduce[itemIndex - 1] = ("\(numberToInsert!)")
                operationsToReduce.remove(at: itemIndex)
                operationsToReduce.remove(at: itemIndex)
                itemIndex = 0
            }
            itemIndex += 1
        }
    }

    func calculate(elements: [String] ) -> [String] {
        self.setUpCalculPriorities(elements: elements)
        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let result = execute(
                with: Calculator.Operations(rawValue: operand)!,
                leftOperand: left,
                rightOperand: right)

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            if let result {
                if Calculator.Operations(rawValue: operand) == .divide {
                    operationsToReduce.insert("\(String(format: "%.2F", result))", at: 0)
                } else {
                    operationsToReduce.insert("\(result)", at: 0)
                }
            }
        }
        return ["\(operationsToReduce[0])"]
    }
}
