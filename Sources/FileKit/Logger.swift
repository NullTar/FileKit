//
//  Logger.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Foundation

public protocol FileLogging: Sendable {
    static func log(_ error: Error, url: URL?)
    static func log(_ message: String)
}

