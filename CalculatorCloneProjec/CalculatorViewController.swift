//
//  ViewController.swift
//  Sample
//
//  Created by Vijay Lal on 06/12/24.
//

import UIKit

class CalculatorViewController: UIViewController {
    
 
    let viewModel: CalcControllerViewModel
    
    lazy var viewFlowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    lazy var calculatorCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: viewFlowlayout)
        view.backgroundColor = .black
        view.register(CalculatorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalculatorHeaderCell.identifier)
        view.showsHorizontalScrollIndicator = false
        view.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.idntifier)
        return view
    }()
    
    init(_ viewModel: CalcControllerViewModel = CalcControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.calculatorCollectionView.dataSource = self
        self.calculatorCollectionView.delegate = self
        self.viewModel.updateView = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.calculatorCollectionView.reloadData()
            }
        }
        initView()
    }
}
extension CalculatorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = calculatorCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalculatorHeaderCell.identifier, for: indexPath) as? CalculatorHeaderCell  else {
            fatalError("failed to dequeue CalcHeaderCell in CalcController")
        }
        header.configure(currentCalcText: self.viewModel.calcHeaderLabel)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let totalCellHeight = view.frame.size.width
        let totalVerticalCellSpacing = CGFloat(10 * 4)
        let window = view.window?.windowScene?.keyWindow
        let toppadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let availableScreenHeight = view.frame.size.height - toppadding - bottomPadding
        let headerHeight = availableScreenHeight - totalCellHeight - totalVerticalCellSpacing
        return CGSize(width: view.frame.size.width, height: headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.calcButtonCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
        let calcButton = self.viewModel.calcButtonCell[indexPath.row]
        cell.configure(with: calcButton)
        if let operation = self.viewModel.operation, self.viewModel.secondNumber == nil {
            if operation.title == calcButton.title {
                cell.setOperationSelected()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let calcButton = self.viewModel.calcButtonCell[indexPath.row]
        switch calcButton {
        case let .number(int) where int == 0:
            return CGSize(
                width: (view.frame.size.width / 5) * 2 + ((view.frame.size.width / 5) / 6),
                height: view.frame.size.width / 5
            )
        default:
            return CGSize(
                width: view.frame.size.width / 5,
                height: view.frame.size.width / 5
            )
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 5) / 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = self.viewModel.calcButtonCell[indexPath.row]
        self.viewModel.didSelectButton(with: buttonCell)
    }
}
extension CalculatorViewController {
    func initView() {
        self.view.addSubview(self.calculatorCollectionView)
        self.calculatorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [calculatorCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
         calculatorCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
         calculatorCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
         calculatorCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ].forEach({ $0.isActive = true })
    }
}

