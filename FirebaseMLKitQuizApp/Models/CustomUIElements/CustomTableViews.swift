//
//  CustomTableViews.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import UIKit

class CustomTableViews {
    
    func styleStandardTableView(rowHeight: CGFloat) -> UITableView {
        let tempTableView = UITableView()
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.separatorStyle = .singleLine
        tempTableView.separatorColor = .lightGray
        tempTableView.rowHeight = rowHeight
        tempTableView.backgroundColor = .white
        tempTableView.layer.cornerRadius = 10
        
        tempTableView.sizeToFit()
        return tempTableView
    }
    
}
