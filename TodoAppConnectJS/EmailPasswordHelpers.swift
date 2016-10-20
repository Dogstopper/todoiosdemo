//
//  EmailAndPasswordHelpers.swift
//  passdown-iOS
//
//  Created by Stephen Schwahn on 1/6/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

class EmailPasswordHelpers {
    
    fileprivate static let _emailRegex = "^[_a-z0-9-\\+]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,6})$"
    fileprivate static let _passwordRegex = "^([a-zA-Z0-9@*#]{4,})$"
    
    static func isValidEmail(_ email: String) -> Bool {
        if email.characters.count <= 0 {
            return false
        }
        
        let match = email.range(of: _emailRegex, options: .regularExpression)
        if match == nil || match!.isEmpty {
            return false
        }
        return true
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let match = password.range(of: _passwordRegex, options: .regularExpression)
        if match == nil || match!.isEmpty {
            return false
        }
        return true
    }

}
