//
//  ScoreboardViewController.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 30.12.2023.
//

import Foundation
import UIKit

class ScoreboardViewController: ViewController {
    
    var date: Date = Date()
    var allScores: [Score] = []
    
    var scoreboardTitleLabel: UILabel = {
        return CustomLabels().styleStandardLabel(text: "Scoreboard", textColor: .systemIndigo, strokeColor: .black, fontSize: 26, isBold: true)
    }()
    var scoreboardTableView: UITableView = {
        return CustomTableViews().styleStandardTableView(rowHeight: 50.0)
    }()
    var tableHeaderView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = .systemRed
        return tempView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreboardTableView.delegate = self
        scoreboardTableView.dataSource = self
        scoreboardTableView.register(ScoreboardTableCell.self, forCellReuseIdentifier: "cell")
        setScoreboardView()
        
    }
}

// MARK: StoreboardView setup
extension ScoreboardViewController {
    func setScoreboardView() {
        navigationItem.titleView = self.scoreboardTitleLabel
        self.view.backgroundColor = .white
        self.scoreboardTableView.tableHeaderView = self.tableHeaderView
        self.view.addSubview(self.scoreboardTableView)
        self.scoreboardTableView.allowsSelection = true
        self.getScoreboardCoreData()
        
        self.setConstraints()
    }
}

// MARK: Get scores from CoreData
extension ScoreboardViewController {
    func getScoreboardCoreData() {
        allScores = GetScores().getAllScores().reversed()
        print(allScores)
        scoreboardTableView.reloadData()
    }
}

// MARK: Tableview
extension ScoreboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScoreboardTableCell
        let currentCellData = allScores[indexPath.row]
        let correctsOverTotal: String = String(allScores[indexPath.row].correctAnswerCount) + "/" + String(allScores[indexPath.row].totalQuestionCount)
        let howLongAgo = calculateHowLongAgo(quizDate: Date.now.timeIntervalSince(allScores[indexPath.row].quizDate))
        
        cell.userNameLabel.text = currentCellData.userName
        cell.categoryLabel.text = "Category: " + String(currentCellData.category)
        cell.correctsOverTotalQuestionsLabel.text = "Score: " + correctsOverTotal
        cell.dateLabel.text = howLongAgo + " ago"
        
        if indexPath.row == 0 {
            cell.setSelected(true, animated: false)
            cell.setHighlighted(true, animated: false)
        }
        
        return cell
    }
    
    
    
}

// MARK: Date calculator
extension ScoreboardViewController {
    func calculateHowLongAgo(quizDate: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month, .day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: quizDate)!
    }
}

// MARK: Set Constraints
extension ScoreboardViewController {
    func setConstraints() {
        setTableViewConstraints()
        
    }
    func setTableViewConstraints() {
        let tableViewConstraints = [
            self.scoreboardTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scoreboardTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scoreboardTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scoreboardTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}

