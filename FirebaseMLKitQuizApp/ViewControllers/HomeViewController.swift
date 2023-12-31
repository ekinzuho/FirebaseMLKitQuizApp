//
//  HomeViewController.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 30.12.2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    var userName: String = ""
    var alphanumericalChars: CharacterSet = .alphanumerics.inverted
    
    var homeTitleLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "Quiz App", textColor: .systemIndigo, strokeColor: .black, fontSize: 30.0, isBold: true)
    }()
    var playButton: UIButton = {
        let tempButton = CustomButtons().styleStandardButton(title: "Play now", titleColor: UIColor.white, backgroundColor: UIColor.systemIndigo)
        return tempButton
    }()
    var nameWarningLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel = CustomLabels().styleStandardLabel(text: "Username should be 3 to 15 characters", textColor: .systemIndigo, strokeColor: .black, fontSize: 18, isBold: false)
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    var nameTextField: UITextField = {
        let tempTextField = UITextField()
        tempTextField.text = ""
        tempTextField.placeholder = "enter username"
        tempTextField.borderStyle = .roundedRect
        return tempTextField
    }()
    var centerStackView: UIStackView = {
        return CustomStackViews().styleStandardStackView(isVerticalAxis: true, spacing: 20.0)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        setHomeView()
    }
    
}

// MARK: HomeView setup
extension HomeViewController {
    func setHomeView() {
        navigationItem.titleView = homeTitleLabel
        self.view.backgroundColor = .white
        addButtonTargets()
        self.centerStackView.addArrangedSubview(self.nameTextField)
        self.centerStackView.addArrangedSubview(self.playButton)
        self.view.addSubview(centerStackView)
        self.view.addSubview(nameWarningLabel)
        nameWarningLabel.isHidden = true
        self.setConstraints()
    }
}

// MARK: HomeView constraints
extension HomeViewController {
    func setConstraints() {
        setNameTextFieldConstraints()
        setPlayButtonConstraints()
        setCenterStackViewConstraints()
        setNameWarningLabelConstraints()
    }
    func setNameTextFieldConstraints() {
        let nameTextFieldConstraints = [
            self.nameTextField.heightAnchor.constraint(equalToConstant: 50),
            self.nameTextField.widthAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(nameTextFieldConstraints)
    }
    func setPlayButtonConstraints() {
        let playButtonConstraints = [
            self.playButton.heightAnchor.constraint(equalToConstant: 50),
            self.playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    func setCenterStackViewConstraints() {
        let stackViewConstraints = [
            self.centerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.centerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.centerStackView.widthAnchor.constraint(equalToConstant: 160),
            self.centerStackView.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
        self.centerStackView.layoutSubviews()
    }
    func setNameWarningLabelConstraints() {
        let nameWarningLabelConstraints = [
            self.nameWarningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.nameWarningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -250),
            self.nameWarningLabel.heightAnchor.constraint(equalToConstant: 30),
            self.nameWarningLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ]
        NSLayoutConstraint.activate(nameWarningLabelConstraints)
    }
}

// MARK: Add button targets
extension HomeViewController {
    func addButtonTargets() {
        self.playButton.addTarget(self, action: #selector(playNowButtonClicked), for: .touchUpInside)
    }
}

// MARK: PlayNowButton clicked
extension HomeViewController {
    @objc private func playNowButtonClicked(sender: UIButton) {
        self.userName = self.nameTextField.text ?? ""
        if self.userName.count < 3 || self.userName.count > 15 {
            self.nameWarningLabel.isHidden = false
        } else {
            self.nameWarningLabel.isHidden = true
            navigateToChooseCategoryViewController()
        }
    }
}

// MARK: Navigate
extension HomeViewController {
    func navigateToChooseCategoryViewController() {
        let chooseCategoryViewController = ChooseCategoryViewController()
        chooseCategoryViewController.userName = self.userName
        navigationController?.pushViewController(chooseCategoryViewController, animated: true)
    }
}


// MARK: UITextFieldDelegate methods
extension HomeViewController: UITextFieldDelegate {
    @objc func keyboardDoneClicked(sender: Any) {
        nameTextField.resignFirstResponder()
        if let inputtedName = nameTextField.text {
            self.userName = inputtedName
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //
        let rangeOfChar = string.rangeOfCharacter(from: self.alphanumericalChars)
        if rangeOfChar == nil {
            return true
        } else {
            return false
        }
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
}
