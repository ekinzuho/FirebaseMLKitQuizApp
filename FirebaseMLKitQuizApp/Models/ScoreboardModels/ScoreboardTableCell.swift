//
//  ScoreboardTableCell.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import UIKit

class ScoreboardTableCell: UITableViewCell {
    
    var userNameLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel = CustomLabels().styleStandardLabel(text: "userName", textColor: .systemIndigo, strokeColor: .black, fontSize: 16, isBold: false)
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    var categoryLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel = CustomLabels().styleStandardLabel(text: "1", textColor: .black, strokeColor: .black, fontSize: 16, isBold: false)
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    var correctsOverTotalQuestionsLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel = CustomLabels().styleStandardLabel(text: "5/10", textColor: .black, strokeColor: .black, fontSize: 16, isBold: false)
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    var dateLabel: UILabel = {
        var tempLabel = UILabel()
        tempLabel = CustomLabels().styleStandardLabel(text: "date", textColor: .black, strokeColor: .black, fontSize: 16, isBold: false)
        tempLabel.textAlignment = .right
        return tempLabel
    }()
    var cellHorizontalStackView: UIStackView = {
        return CustomStackViews().styleStandardStackView(isVerticalAxis: false, spacing: 0)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        cellHorizontalStackView.addArrangedSubview(userNameLabel)
        cellHorizontalStackView.addArrangedSubview(categoryLabel)
        cellHorizontalStackView.addArrangedSubview(correctsOverTotalQuestionsLabel)
        cellHorizontalStackView.addArrangedSubview(dateLabel)
        addSubview(cellHorizontalStackView)
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        let cellHorizontalStackViewConstraints = [
            self.cellHorizontalStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ]
        NSLayoutConstraint.activate(cellHorizontalStackViewConstraints)
        self.cellHorizontalStackView.frame = self.frame
        
        let userNameLabelConstraints = [
            self.userNameLabel.leadingAnchor.constraint(equalTo: cellHorizontalStackView.leadingAnchor),
            self.userNameLabel.topAnchor.constraint(equalTo: cellHorizontalStackView.topAnchor),
            self.userNameLabel.bottomAnchor.constraint(equalTo: cellHorizontalStackView.bottomAnchor),
            self.userNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ]
        NSLayoutConstraint.activate(userNameLabelConstraints)
        let categoryConstraints = [
            self.categoryLabel.topAnchor.constraint(equalTo: cellHorizontalStackView.topAnchor),
            self.categoryLabel.bottomAnchor.constraint(equalTo: cellHorizontalStackView.bottomAnchor),
            self.categoryLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ]
        NSLayoutConstraint.activate(categoryConstraints)
        let correctsOverTotalQuestionsLabelConstraints = [
            self.correctsOverTotalQuestionsLabel.topAnchor.constraint(equalTo: cellHorizontalStackView.topAnchor),
            self.correctsOverTotalQuestionsLabel.bottomAnchor.constraint(equalTo: cellHorizontalStackView.bottomAnchor),
            self.correctsOverTotalQuestionsLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ]
        NSLayoutConstraint.activate(correctsOverTotalQuestionsLabelConstraints)
        let dateLabelConstraints = [
            self.dateLabel.trailingAnchor.constraint(equalTo: cellHorizontalStackView.trailingAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: cellHorizontalStackView.topAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: cellHorizontalStackView.bottomAnchor),
            self.dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
        ]
        NSLayoutConstraint.activate(dateLabelConstraints)
        
    }
    
}
