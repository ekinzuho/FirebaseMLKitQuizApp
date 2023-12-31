//
//  CustomLabels.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import UIKit

class CustomLabels {
    
    func styleStandardLabel(text: String, textColor: UIColor, strokeColor: UIColor, fontSize: CGFloat, isBold: Bool) -> UILabel {
        let attributes = [
            NSAttributedString.Key.strokeColor: strokeColor,
            NSAttributedString.Key.strokeWidth: -0.5,
            NSAttributedString.Key.foregroundColor: textColor,
            //NSAttributedString.Key.backgroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: (isBold ? .bold : .regular))
        ] as [NSAttributedString.Key: Any]
        let tempLabel = UILabel()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        tempLabel.numberOfLines = 0
        tempLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        tempLabel.layer.cornerRadius = 10
        tempLabel.sizeToFit()
        return tempLabel
    }
    
}
