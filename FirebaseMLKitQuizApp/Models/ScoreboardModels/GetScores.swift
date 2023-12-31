//
//  GetScores.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import CoreData
import UIKit

class GetScores {
    
    func getAllScores() -> [Score] {
        var scoreArray: [Score] = []
        let appDelegate = UIApplication.shared.delegate
         as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        request.returnsObjectsAsFaults = false
        request.returnsDistinctResults = false
        
        do {
            let requestResult = try viewContext.fetch(request)
            if requestResult.count > 0 {
                for result in requestResult as! [NSManagedObject] {
                    var score = Score()
                    score.userName = result.value(forKey: "userName") as! String
                    score.category = result.value(forKey: "category") as! Int
                    score.totalQuestionCount = result.value(forKey: "totalQuestionCount") as! Int
                    score.correctAnswerCount = result.value(forKey: "correctAnswerCount") as! Int
                    score.quizDate = result.value(forKey: "quizDate") as! Date
                    scoreArray.append(score)
                }
            }
            
            
        } catch {
            print(error)
        }
        
        return scoreArray
    }
    
}
