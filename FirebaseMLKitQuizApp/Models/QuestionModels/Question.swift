//
//  Question.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation

struct Question: Decodable {
    /*
    enum Category: String, Codable {
        case first, second, third
    }
    */
    var category: Int
    var question: String
    var answerLeft: String
    var answerRight: String
    var correctAnswer: Int
}
