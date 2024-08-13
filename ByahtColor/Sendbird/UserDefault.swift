//
//  UserDefault.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {

    private let key: String
    private let defaultValue: Value
    private let container: UserDefaults

    public init(key: String, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    public var wrappedValue: Value {
        get {
            return (container.object(forKey: key) as? Value) ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
