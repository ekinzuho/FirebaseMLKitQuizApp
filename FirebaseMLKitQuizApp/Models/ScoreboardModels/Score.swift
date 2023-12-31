//
//  Score.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation

struct Score: Decodable {
    
    var userName: String = ""
    var category: Int = 0
    var totalQuestionCount: Int = 0
    var correctAnswerCount: Int = 0
    var quizDate: Date = Date.now
    
}
