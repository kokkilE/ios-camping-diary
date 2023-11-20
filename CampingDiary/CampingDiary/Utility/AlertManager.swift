//
//  AlertManager.swift
//  CampingDiary
//
//  Created by 조향래 on 11/17/23.
//

import UIKit

final class AlertManager {
    static func getCompletionAlert(message: String, completion: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
        
        alert.addAction(confirmAction)
        
        return alert
    }
    
    static func getErrorAlert(error: LocalizedError?) -> UIAlertController? {
        guard let error else { return nil }
        
        let alert = UIAlertController(title: "", message: error.errorDescription, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(confirmAction)
        
        return alert
    }
    
    static func getSingleActionSheet(actionName: String, completion: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: actionName, style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        return alert
    }
}
