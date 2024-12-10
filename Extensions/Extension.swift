//
//  Extension.swift
//  Sample
//
//  Created by Vijay Lal on 08/12/24.
//

import Foundation

extension Double {
    var toInt: Int? {
        return Int(self)
    }
}
extension String {
    var toDouble: Double? {
        return Double(self)
    }
}
extension FloatingPoint {
    var isInteger: Bool { return rounded() == self }
}
