//
//  CustomStackViews.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import UIKit

class CustomStackViews {
    
    func styleStandardStackView(isVerticalAxis: Bool, spacing: CGFloat) -> UIStackView {
        let tempStackView = UIStackView()
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.axis = (isVerticalAxis ? .vertical : .horizontal)
        tempStackView.spacing = spacing
        tempStackView.distribution = .equalSpacing
        tempStackView.layer.cornerRadius = 10
        tempStackView.sizeToFit()
        return tempStackView
    }
    
}
