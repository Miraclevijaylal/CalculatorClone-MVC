//
//  CalcControllerViewModel.swift
//  Sample
//
//  Created by Vijay Lal on 06/12/24.
//

import Foundation
enum CurrentNumber {
    case FirstNumber
    case SecondNumber
}
class CalcControllerViewModel {
    var updateView: (() -> Void)?
    //MARK: - TableView DataSource Array
    let calcButtonCell: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiplication,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals]
    //MARK: - Normal Variables
    private(set) lazy var calcHeaderLabel: String = (self.firstNumber ?? "0").description
    private(set) var currentNumber: CurrentNumber = .FirstNumber
    private(set) var firstNumber: String? = nil { didSet {self.calcHeaderLabel = self.firstNumber?.description ?? "0"}}
    private(set) var secondNumber: String? = nil { didSet { self.calcHeaderLabel = self.secondNumber?.description ?? "0"}}
    private(set) var operation: CalculatorOperation? = nil
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
    //MARK: - Memory Variables
    private(set) var prevNumber: String? = nil
    private(set) var previousOperation: CalculatorOperation? = nil
}
extension CalcControllerViewModel {
    public func didSelectButton(with calcButton: CalculatorButton) {
        switch calcButton {
        case .allClear:
            self.didSelectOfAllClear()
        case .plusMinus: self.didSelectPlusMinus()
        case .percentage: self.didSelectPercentage()
        case .divide: self.didSelectOperation(with: .divide)
        case .multiplication: self.didSelectOperation(with: .multiplication)
        case .subtract: self.didSelectOperation(with: .subtract)
        case .add: self.didSelectOperation(with: .add)
        case .equals: self.didSelectEqualButton()
        case .number(let number): self.didSelectNumber(with: number)
        case .decimal: self.didselectDecial()
        }
        if let firstNumber = self.firstNumber?.toDouble {
            if firstNumber.isInteger {
                self.firstNumberIsDecimal = false
                self.firstNumber = firstNumber.toInt?.description
            }
        }
        if let secondNumber = self.secondNumber?.toDouble {
            if secondNumber.isInteger {
                self.secondNumberIsDecimal = false
                self.secondNumber = secondNumber.toInt?.description
            }
        }
        self.updateView?()
    }
    private func didSelectOfAllClear() {
        self.calcHeaderLabel = "0"
        self.currentNumber = .FirstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.prevNumber = nil
        self.previousOperation = nil
    }
}
// MARK: - Selecting Numbers
extension CalcControllerViewModel {
    private func didSelectNumber(with number: Int) {
        if self.currentNumber == .FirstNumber {
            if var firstNumber = self.firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.prevNumber = firstNumber
            } else {
                self.firstNumber = number.description
                self.prevNumber = number.description
            }
        } else {
            if var secondNumber = self.secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.prevNumber = secondNumber
            } else {
                self.secondNumber = number.description
                self.prevNumber = number.description
            }
        }
    }
}
extension CalcControllerViewModel {
    private func didSelectEqualButton() {
        if let operation = self.operation,
           let firstNuimber = self.firstNumber?.toDouble,
           let secondNumber = self.secondNumber?.toDouble {
            // Equals is pressed normally after firstNumber, then an operation, then a seconNumber
            let result = self.getOperationresult(operation, firstNuimber, secondNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description: result.toInt?.description
            self.secondNumber = nil
            self.previousOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .FirstNumber
        }
        else if let prevOperation = self.previousOperation,
                let firstNumber = self.firstNumber?.toDouble,
                let previousNumber = self.prevNumber?.toDouble {
            // This will update the calculated based on previously selected number and arithmatic operation
            let result = self.getOperationresult(prevOperation, firstNumber, previousNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description: result.toInt?.description
            self.firstNumber = resultString
        }
    }
    private func didSelectOperation(with operation: CalculatorOperation) {
        if self.currentNumber == .FirstNumber {
            self.operation = operation
            self.currentNumber = .SecondNumber
        } else if self.currentNumber == .SecondNumber {
            if let previosOperation = self.operation,
               let firstNumber = self.firstNumber?.toDouble,
               let secondNumber = self.secondNumber?.toDouble {
                // Do previous Operation first
                let result = self.getOperationresult(previosOperation, firstNumber, secondNumber)
                let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
                self.secondNumber = nil
                self.firstNumber = resultString
                self.currentNumber = .SecondNumber
                self.operation = operation
            } else {
                // Else switch opertaion
                self.operation = operation
            }
        }
    }
    //MARK: - Helper
    private func getOperationresult(_ operation: CalculatorOperation, _ firstNumber: Double?, _ secondNumber: Double?) -> Double {
        guard let firstNumber = firstNumber, let secondNumber = secondNumber else { return 0 }
        switch operation {
        case .divide:
            return (firstNumber / secondNumber)
        case .multiplication:
            return (firstNumber * secondNumber)
        case .subtract:
            return (firstNumber - secondNumber)
        case .add:
            return (firstNumber + secondNumber)
        }
    }
}
//MARK: - Action Button
extension CalcControllerViewModel {
    private func didSelectPlusMinus() {
        if self.currentNumber == .FirstNumber, var number = self.firstNumber {
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            self.firstNumber = number
            self.prevNumber = number
        }
        else if self.currentNumber == .SecondNumber, var number = self.secondNumber {
            if number.contains("-") {
                number.removeFirst()
            } else {
                number.insert("-", at: number.startIndex)
            }
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    private func didSelectPercentage() {
        if self.currentNumber == .FirstNumber, var number = self.firstNumber?.toDouble {
            number /= 100
            
            if number.isInteger {
                self.firstNumber = number.toInt?.description
            } else {
                self.firstNumber = number.description
                self.firstNumberIsDecimal = true
            }
        }
        else if self.currentNumber == .SecondNumber, var number = self.secondNumber?.toDouble {
            number /= 100
            if number.isInteger {
                self.secondNumber = number.toInt?.description
            } else {
                self.secondNumber = number.description
                self.secondNumberIsDecimal = true
            }
        }
    }
    private func didselectDecial() {
        if self.currentNumber == .FirstNumber {
            self.firstNumberIsDecimal = true
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            } else if self.firstNumber == nil {
                self.firstNumber = "0."
            }
        } else if self.currentNumber == .SecondNumber {
            self.secondNumberIsDecimal = true
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            } else if self.secondNumber == nil {
                self.secondNumber = "0."
            }
        }
    }
}

