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

    /// Check if the entered expression is correct or not
    /// - Parameter elements: the array containing elements of the expression
    /// - Returns: true or false based on the condition
    func expressionIsCorrect(elements: [String] ) -> Bool {
        return Operations.allCases.allSatisfy { elements.last != $0.rawValue }
    }

    /// Check if the expression has enough elements, at least 3 (left, sign, right)
    /// - Parameter elements: the array containing elements of the expression
    /// - Returns: true or false based on the condition
    func expressionHaveEnoughElement(elements: [String] ) -> Bool {
        return elements.count >= 3
    }

    /// Check if we can add an operator to the current expression
    /// - Parameter elements: the array containing elements of the expression
    /// - Returns: true if the current expression does not end with an operator, false otherwise
    func canAddOperator(elements: [String] ) -> Bool {
        return Operations.allCases.allSatisfy { elements.last != $0.rawValue }
    }

    /// Check if an expression has a result
    /// - Parameter calculText: text in which we check if the result is present
    /// - Returns: true or false
    func expressionHaveResult(calculText: String) -> Bool {
        return calculText.firstIndex(of: "=") != nil
    }

    /// List of different operations and their signs
    enum Operations: String, CaseIterable {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "÷"
    }

    /// Perform a basic (non-priority) operation
    /// - Parameters:
    ///   - operation: operation sign
    ///   - leftOperand: left operand
    ///   - rightOperand: right operand of the operation
    /// - Returns: result of the operation between the two operands based on the sign

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

    /// Perform calculations in the array of elements based on priorities
    /// - Parameter elements: the array containing elements of the expression
    /// - Returns: another array of elements (3) that will be used to finish the calculation

    private func setUpCalculPriorities(elements: [String]) -> [String] {
        var index = 0
        var mutableElements = elements /// create a copy of the passed-in array
        while index < mutableElements.count {
            /// if we find a "*" or "÷" sign, then...
            if mutableElements[index] == "*" || mutableElements[index] == "÷" {
                /// get the operation sign at the current index
                /// then take the left operand of the operation at index - 1
                /// and the right operand at index + 1
                if let operationSign = Calculator.Operations(rawValue: mutableElements[index]) {
                    if let leftOperand = Double(mutableElements[index - 1]),
                        let rightOperand = Double(mutableElements[index + 1]) {

                        /// calculate the result by performing the operation
                        let result = execute(
                            with: operationSign,
                            leftOperand: leftOperand,
                            rightOperand: rightOperand)
                        guard let result else {
                            return []
                        }
                        /// if we have a non-nil result
                        /// replace the left operand with the value of the current result
                        mutableElements[index - 1] = ("\(roundResult(result))")
                        /// remove the element at the current index, which is the operation sign
                        /// this shifts the array one step to the left
                        mutableElements.remove(at: index)
                        /// remove the element at the current index, which has become the right operand
                        mutableElements.remove(at: index)
                        index = 0 /// reset the index to 0 to reiterate through the array
                    }
                }
            }

            index += 1
        }
        return mutableElements
    }

    /// Return the result of the calculation of an expression with priorities
    /// - Parameter elements: the array containing elements of the expression
    /// - Returns: an array containing the result element

    func calculate(elements: [String] ) -> [String]? {
        /// Create a local copy of operations
        /// Assign this copy the value of the array already sorted with priorities
        var operationsToReduce = self.setUpCalculPriorities(elements: elements)

        // Iterate over operations while an operand is still here
        while operationsToReduce.count > 1 {

            /// We have an array of three elements (left, operation sign, right)
            /// First, we get the operands and try to cast them to Double

            if let leftOperand = Double(operationsToReduce[0]), let rightOperand = Double(operationsToReduce[2]) {

                /// If the cast works, we try to get the operation sign

                let operand = Calculator.Operations(rawValue: operationsToReduce[1])
                guard let operand else { return [] }

                /// Once we have all three elements, we perform the operation and store it in a result variable

                let result = execute(
                    with: operand,
                    leftOperand: leftOperand,
                    rightOperand: rightOperand)

                /// We "remove" the first three elements from the array
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                if let result { /// if we have a result...
                    if operand == .divide { /// if the operation sign was division, we format the result
                        operationsToReduce.insert("\(String(format: "%.2F", result))", at: 0)
                    } else { /// otherwise, we round it here with roundResult
                        operationsToReduce.insert("\(roundResult(result))", at: 0)
                    }
                    /// Insert the result at the beginning of the array
                }
            }
        }
        if let resultToDisplay = operationsToReduce.first {
            return ["\(resultToDisplay)"]
        } else {
            return nil
        }
        /// If we have a result here, return it; otherwise, return nil
    }

    func roundResult(_ result: Double) -> String {
        result.truncatingRemainder(dividingBy: 1.0) == 0.0 ? "\(Int(result))" : "\(String(format: "%.2F", result))"
    }
}
