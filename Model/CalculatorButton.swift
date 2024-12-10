//
//  CalculatorButton.swift
//  Sample
//
//  Created by Vijay Lal on 06/12/24.
//

import Foundation
import UIKit

enum CalculatorButton {
    case allClear
    case plusMinus
    case percentage
    case divide
    case multiplication
    case subtract
    case add
    case equals
    case number(Int)
    case decimal
    
    init(calcButton: CalculatorButton) {
        switch calcButton {
        case .allClear, .plusMinus, .percentage, .divide, .multiplication, .subtract, .add, .equals, .decimal:
            self = calcButton
        case .number(let int):
            if int.description.count == 1 {
                self = calcButton
            } else {
                fatalError("Int is not 1 digit")
            }
        }
    }
}
extension CalculatorButton {
    
    var title: String {
        switch self {
        case .allClear:
            return "AC"
        case .plusMinus:
            return "+/-"
        case .percentage:
            return "%"
        case .divide:
            return "÷"
        case .multiplication:
            return "x"
        case .subtract:
            return "-"
        case .add:
            return "+"
        case .equals:
            return "="
        case .number(let int):
            return int.description
        case .decimal:
            return "."
        }
    }
    
    var color: UIColor {
        switch self {
        case .allClear,.percentage, .plusMinus:
            return .lightGray
        case .divide, .multiplication,.subtract, .add, .equals:
            return .systemOrange
        case .number, .decimal:
            return .darkGray
        }
    }
    
    var selectedColor: UIColor? {
        switch self {
        case .allClear, .plusMinus, .percentage, .equals, .number, .decimal:
            return nil
        case .divide, .multiplication, .subtract, .add:
            return .white
        }
    }
}
