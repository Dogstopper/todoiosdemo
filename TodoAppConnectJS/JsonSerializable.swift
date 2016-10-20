//
//  JsonSerializable.swift
//  TodoAppConnectJS
//
//  Created by Stephen Schwahn on 10/20/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

protocol JsonSerializable {
    init(json: [String: AnyObject])
    func serialize() -> [String: AnyObject]
    func deserialize(json: [String: AnyObject])
}
