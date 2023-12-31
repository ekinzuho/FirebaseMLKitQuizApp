//
//  DeleteScores.swift
//  FirebaseMLKitQuizApp
//
//  Created by Ekin Zuhat Yaşar on 31.12.2023.
//

import Foundation
import CoreData
import UIKit

class DeleteScores {
    
    func deleteScores()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
        } catch {
            print(error)
        }
    }
    
}
