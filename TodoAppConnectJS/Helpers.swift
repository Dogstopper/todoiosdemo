//
//  Helpers.swift
//  passdown-iOS
//
//  Created by Stephen Schwahn on 1/13/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    
    static func displayAlertWithTitle(_ message: String?, viewController: UIViewController) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func registerUser(email: String, password: String, with success: @escaping () -> (), failure: @escaping (String) -> ()) {
        // Attempt to register with our API
        API.request(.createNewAccount(email, password), completionHandler: { json, error in
            if error == .NO_ERROR {
                success()
            }
            else {
                failure(error.getDescription())
            }
        })
    }

    static func loginUser(email: String, password: String, with success: @escaping (String, String) -> (), failure: @escaping (String) -> ()) {
        // Attempt to login to our API
        API.request(.loginEmail(email, password), completionHandler: { json, error in
            if error == .NO_ERROR {
                let accessToken = json["accessToken"] as! String
                success(email, accessToken)
            } else {
                failure(error.getDescription())
            }
        })
    }
    
    static func getUser(accessToken: String, with success: @escaping () -> (), failure: @escaping (String) -> ()) {
        API.request(.getUser(accessToken), completionHandler: { json, error in
            if error == .NO_ERROR {
                // Logged In
                User.currentUser = User(json: json)
                success()
            }
        
            else {
                User.currentUser = User()
                failure(error.getDescription())
            }
        })
    }

}
