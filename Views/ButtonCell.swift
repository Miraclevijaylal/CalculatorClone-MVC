//
//  ButtonCell.swift
//  Sample
//
//  Created by Vijay Lal on 06/12/24.
//

import Foundation
import UIKit

class ButtonCell: UICollectionViewCell {
    private(set) var calculatorButton: CalculatorButton!
    static let idntifier = "ButtonCell"
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .regular)
        label.text = "Error"
        return label
    }()
     public func configure(with calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        self.titlelabel.text = calculatorButton.title
        self.backgroundColor = calculatorButton.color
        switch calculatorButton {
        case .allClear, .plusMinus, .percentage:
            self.titlelabel.textColor = .black
        default:
            self.titlelabel.textColor = .white
        }
        self.setupUI()
    }
    public func setOperationSelected() {
        self.titlelabel.textColor = .systemOrange
        self.backgroundColor = .white
    }
    private func setupUI() {
        self.addSubview(titlelabel)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        switch self.calculatorButton {
        case let .number(int) where int == 0:
            self.layer.cornerRadius = 36
            let extraSpace = self.frame.width - self.frame.height
            [self.titlelabel.heightAnchor.constraint(equalToConstant: self.frame.height),
             self.titlelabel.widthAnchor.constraint(equalToConstant: self.frame.width),
             self.titlelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             self.titlelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             self.titlelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -extraSpace)
            ].forEach({ $0.isActive = true })
        default:
            self.layer.cornerRadius = self.frame.size.width / 2
            [self.titlelabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             self.titlelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             self.titlelabel.heightAnchor.constraint(equalTo: self.heightAnchor),
             self.titlelabel.widthAnchor.constraint(equalTo: self.widthAnchor)
            ].forEach({ $0.isActive = true })
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titlelabel.removeFromSuperview()
    }
}
