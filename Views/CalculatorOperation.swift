//
//  CalculatorOperation.swift
//  Sample
//
//  Created by Vijay Lal on 08/12/24.
//

import Foundation

enum CalculatorOperation {
    case divide
    case multiplication
    case subtract
    case add
    
    var title: String {
        switch self {
        case .divide:
            return "÷"
        case .multiplication:
            return "x"
        case .subtract:
            return "-"
        case .add:
            return "+"
        }
    }
}

