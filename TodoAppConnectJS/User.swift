//
//  User.swift
//  passdown-iOS
//
//  Created by Stephen Schwahn on 1/6/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

public class User : JsonSerializable {
    
    public static var currentUser: User = User()
    
    var email : String = ""
    var accessToken: String = "" {
        didSet {
            setAccessTokenDefault()
        }
    }
    
    
    init() {}
    
    required public init(json: [String: AnyObject]) {
        var json = json
        if let userJson = json["user"] as? [String: AnyObject] {
            json = userJson
        }
        print(json)
        self.email = json["email"] as? String ?? email
        self.accessToken = json["accessToken"] as? String ?? accessToken
        
        setAccessTokenDefault()
    }
    
    open func serialize() -> [String : AnyObject] {
        return [:]
    }
    
    open func deserialize(json: [String : AnyObject]) {
        
    }
    
    fileprivate func setAccessTokenDefault() {
        let defaults = UserDefaults.standard
        if accessToken == "" {
            defaults.removeObject(forKey: "accessToken")
            
        } else {
            defaults.setValue(accessToken, forKey: "accessToken")
        }
        defaults.synchronize()
    }
    
}
