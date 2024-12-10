//
//  CalculatorHeaderCell.swift
//  Sample
//
//  Created by Vijay Lal on 06/12/24.
//

import Foundation
import UIKit

class CalculatorHeaderCell: UICollectionReusableView {
    static let identifier = "calculatorHeaderCell"
    lazy var labelName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 72, weight: .regular)
        label.text = "Error"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(currentCalcText: String) {
        self.labelName.text = currentCalcText
    }
    private func initViews() {
        self.backgroundColor = .black
        self.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        [labelName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         labelName.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ].forEach({ $0.isActive = true })
    }
}
