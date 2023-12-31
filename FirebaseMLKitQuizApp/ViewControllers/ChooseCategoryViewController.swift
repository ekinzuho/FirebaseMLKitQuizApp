//
//  ChooseCategoryViewController.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 30.12.2023.
//

import Foundation
import UIKit

class ChooseCategoryViewController: UIViewController {
    
    var userName: String = ""
    var chosenCategory: Int = 0
    
    var chooseCategoryTitleLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "Choose a category", textColor: .systemIndigo, strokeColor: .black, fontSize: 33, isBold: true)
    }()
    var firstCategoryButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "First category", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
    }()
    var secondCategoryButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "Second category", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
    }()
    var thirdCategoryButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "Third category", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
    }()
    var categoryButtonsStackView: UIStackView = {
        return CustomStackViews().styleStandardStackView(isVerticalAxis: true, spacing: 10.0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChooseCategoryView()
    }
    
}

// MARK: ChooseCategoryView setup
extension ChooseCategoryViewController {
    func setChooseCategoryView() {
        self.view.backgroundColor = .white
        navigationItem.titleView = chooseCategoryTitleLabel
        addButtonTargets()
        self.categoryButtonsStackView.addArrangedSubview(self.firstCategoryButton)
        self.categoryButtonsStackView.addArrangedSubview(self.secondCategoryButton)
        self.categoryButtonsStackView.addArrangedSubview(self.thirdCategoryButton)
        self.view.addSubview(categoryButtonsStackView)
        self.setConstraints()
        
    }
}

// MARK: Add button targets
extension ChooseCategoryViewController {
    func addButtonTargets() {
        self.firstCategoryButton.addTarget(self, action: #selector(firstCategoryChosen), for: .touchUpInside)
        self.secondCategoryButton.addTarget(self, action: #selector(secondCategoryChosen), for: .touchUpInside)
        self.thirdCategoryButton.addTarget(self, action: #selector(thirdCategoryChosen), for: .touchUpInside)
    }
}

// MARK: ChooseCategoryView constraints
extension ChooseCategoryViewController {
    func setConstraints() {
        setFirstCategoryButtonConstraints()
        setSecondCategoryButtonConstraints()
        setThirdCategoryButtonConstraints()
        setCategoryButtonsStackViewConstraints()
    }
    func setFirstCategoryButtonConstraints() {
        let firstCategoryButtonConstraints = [
            self.firstCategoryButton.heightAnchor.constraint(equalToConstant: 40),
            self.firstCategoryButton.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(firstCategoryButtonConstraints)
    }
    func setSecondCategoryButtonConstraints() {
        let secondCategoryButtonConstraints = [
            self.secondCategoryButton.heightAnchor.constraint(equalToConstant: 40),
            self.secondCategoryButton.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(secondCategoryButtonConstraints)
    }
    func setThirdCategoryButtonConstraints() {
        let thirdCategoryButtonConstraints = [
            self.thirdCategoryButton.heightAnchor.constraint(equalToConstant: 40),
            self.thirdCategoryButton.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(thirdCategoryButtonConstraints)
    }
    func setCategoryButtonsStackViewConstraints() {
        let stackViewConstraints = [
            self.categoryButtonsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.categoryButtonsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.categoryButtonsStackView.widthAnchor.constraint(equalToConstant: 180),
            self.categoryButtonsStackView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
        self.categoryButtonsStackView.layoutSubviews()
    }
    
}



// MARK: CategoryHandling
extension ChooseCategoryViewController {
    @objc func firstCategoryChosen() {
        self.chosenCategory = 1
        navigateToPlayView()
    }
    @objc func secondCategoryChosen() {
        self.chosenCategory = 2
        navigateToPlayView()
    }
    @objc func thirdCategoryChosen() {
        self.chosenCategory = 3
        navigateToPlayView()
    }
}

// MARK: Navigate next
extension ChooseCategoryViewController {
    func navigateToPlayView() {
        let playViewController = PlayViewController()
        playViewController.chosenCategory = self.chosenCategory
        playViewController.userName = self.userName
        navigationController?.pushViewController(playViewController, animated: true)
    }
}

