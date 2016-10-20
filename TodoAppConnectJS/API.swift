//
//  API.swift
//  passdown-iOS
//
//  Created by Stephen Schwahn on 1/13/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import Alamofire


open class API {
    
    static let host = "http://localhost:3000/api/v1/"
    
    public enum Endpoints {
        // Used for account management
        case loginEmail(String, String)         // Email, password
        case logout(String)                     // API Access Token
        case createNewAccount(String, String)   // Email, password
        case getUser(String)                    // Access Token
        
        // Used for todo module
        case getAllTodos(String)                // Access Token
        case getTodo(String, String)            // Access Token, Todo id
        case createTodo(String, String, String) // Access Token, todo item, date string
        case deleteTodo(String, String)         // Access Token, Todo id

        public var method: HTTPMethod {
            switch self {
            case .loginEmail, .logout, .createNewAccount, .createTodo:
                return .post
            case .getUser, .getAllTodos, .getTodo:
                return .get
            case .deleteTodo:
                return .delete
            }
        }
        
        public var url: String {
            switch self {
            case .loginEmail:
                return host + "auth/login"
            case .logout:
                return host + "auth/logout"
            case .createNewAccount:
                return host + "auth/signup"
            case .getUser:
                return host + "user/"
            case .getAllTodos:
                return host + "todo/"
            case .getTodo(_, let todoId):
                return host + "todo/\(todoId)"
            case .createTodo:
                return host + "todo/"
            case .deleteTodo(_, let todoId):
                return host + "todo/\(todoId)"
            }
        }
        
        public var parameters: [String: Any] {
            switch self {
            case .loginEmail(let email, let password):
                return ["email": email, "password": password]
            case .logout(_):
                return [:]
            case .createNewAccount(let email, let password):
                return ["email": email, "password": password]
            case .createTodo(_, let todoItem, let todoDate):
                return ["todo": todoItem, "date": todoDate]
            default:
                return [:]
            }
        }
        
        public var headers: [String: String] {
            switch self {
            case .logout(let accessToken):
                return ["Authorization": "\(accessToken)"]
            case .getUser(let accessToken):
                return ["Authorization": "\(accessToken)"]
            case .createTodo(let accessToken, _, _):
                return ["Authorization": "\(accessToken)"]
            case .deleteTodo(let accessToken, _):
                return ["Authorization": "\(accessToken)"]
            case .getAllTodos(let accessToken):
                return ["Authorization": "\(accessToken)"]
            case .getTodo(let accessToken, _):
                return ["Authorization": "\(accessToken)"]
            default:
                return [:]
            }
        }
    }
    
    open static func request(_ endpoint: API.Endpoints, completionHandler: @escaping (([String : AnyObject], API.Errors) -> Void)) {
        print("API Call: \(endpoint)")
        
        SessionManager.default.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: URLEncoding.default, headers: endpoint.headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: AnyObject] {
                    if response.response?.statusCode != 200 {
                        completionHandler(json, .INTERNAL_SERVER_ERROR)
                    } else {
                        completionHandler(json, .NO_ERROR)
                    }
                } else if let string = value as? String {
                    completionHandler(["status" : string as AnyObject], .NO_ERROR)
                } else {
                    completionHandler([:], .INTERNAL_SERVER_ERROR)
                    print("The request \(endpoint) succeeded but the data could not be parsed into [String : AnyObject]. Consider trying the asArray method.")
                }
            case .failure(_):
                completionHandler([:], .ALAMOFIRE_ERROR)
            }
        }
    }
    
    open static func request(_ endpoint: API.Endpoints, asArray completionHandler: @escaping (([[String: AnyObject]], API.Errors) -> Void)) {
        print("API Call: \(endpoint)")
        
        SessionManager.default.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: URLEncoding.default, headers: endpoint.headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [[String: AnyObject]] {
                    if response.response?.statusCode != 200 {
                        let error = API.Errors.INTERNAL_SERVER_ERROR
                        completionHandler(json, error)
                    } else {
                        completionHandler(json, .NO_ERROR)
                    }
                } else {
                    if let error = value as? [String: AnyObject] {
                        let apiErr = API.Errors.INTERNAL_SERVER_ERROR
                        completionHandler([error], apiErr)
                        print("The request \(endpoint) succeeded but the data could not be parsed into [[String : AnyObject]]. Consider trying the non-array method.")
                    }
                }
            case .failure(_):
                completionHandler([[:]], .ALAMOFIRE_ERROR)
            }
        }
    }
    
    public enum Errors : Int {
        case NO_ERROR                       = -1
        case INTERNAL_SERVER_ERROR          = 5
        case UNSPECIFIED_ERROR              = 15;
        case ALAMOFIRE_ERROR                = 100;
        
        public func getDescription() -> String {
            switch(self) {
            case .NO_ERROR:
                return ""
            case .INTERNAL_SERVER_ERROR:
                return "Internal server error. Try again later."
            case .UNSPECIFIED_ERROR:
                return "The error is unspecified."
            case .ALAMOFIRE_ERROR:
                return "It appears you're not connected to a network. Turn on Wi-Fi or mobile data and try again."
            }
        }
    }
}
