//
//  SaveScore.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import CoreData
import UIKit

class SaveScore {
    
    func saveNewScore(userName: String, category: Int, totalQuestionCount: Int, correctAnswerCount: Int, quizDate: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let newScore = NSEntityDescription.insertNewObject(forEntityName: "Scores", into: viewContext)
        
        newScore.setValue(userName, forKey: "userName")
        newScore.setValue(category, forKey: "category")
        newScore.setValue(totalQuestionCount, forKey: "totalQuestionCount")
        newScore.setValue(correctAnswerCount, forKey: "correctAnswerCount")
        newScore.setValue(quizDate, forKey: "quizDate")
        
        do {
            try viewContext.save()
            print("Saved new score to CoreData")
        } catch {
            print(error)
        }
    }
    
}
