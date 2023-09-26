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
        return elements.last != "+" && elements.last != "-"
    }
    
    func expressionHaveEnoughElement(elements: [String] ) -> Bool {
        return elements.count >= 3
    }
    
    func canAddOperator(elements: [String] ) -> Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    func expressionHaveResult(calculText: String) -> Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    enum Operations: String {
        case add = "+"
        case subtract = "-"
    }
    
    func execute(with operation: Calculator.Operations, leftOperand: Int, rightOperand: Int) -> Int {
        switch operation {
        case .add:
            return leftOperand + rightOperand
        case .subtract:
            return leftOperand - rightOperand
        }
    }
}
