//
//  Configuration.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Synchronization

@available(iOS 18.0, *)
public enum FileConfiguration {
    private static let storage = Mutex<(any FileLogging.Type)?>(nil)

    public static var logger: (any FileLogging.Type)? {
        get {
            storage.withLock { $0 }
        }
        set {
            storage.withLock { $0 = newValue }
        }
    }
}
