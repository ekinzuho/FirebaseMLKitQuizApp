//
//  CustomButtons.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import UIKit

class CustomButtons {
    
    func styleStandardButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
        let tempButton = UIButton(type: .custom)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = backgroundColor
        tempButton.setTitle(title, for: .normal)
        tempButton.setTitleColor(titleColor, for: .normal)
        tempButton.titleLabel?.numberOfLines = 0
        tempButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        tempButton.layer.cornerRadius = 10
        tempButton.layer.borderWidth = 1
        tempButton.sizeToFit()
        return tempButton
    }
    
}
