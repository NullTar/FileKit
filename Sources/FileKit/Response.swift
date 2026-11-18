//
//  Response.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Foundation

/// 文件操作的执行结果
///
/// 用于统一表示文件操作的成功或失败状态, 并提供便捷的状态判断和错误日志记录
public extension File {
    struct Response {
        /// 文件操作的内部状态
        private let status: Status
    }
}

/// 文件操作结果的状态定义
extension File.Response {
    enum Status {
        /// 操作成功
        case success

        /// 文件操作失败
        ///
        /// - Parameters:
        ///   - error: 操作过程中发生的错误
        ///   - url: 发生错误时对应的文件 URL，可以为 `nil`
        case failed(Error, URL?)
    }

    /// 默认不做任何处理
    func action(_ error: Error, _ url: URL?) {}
}

/// 文件操作结果的创建方法
extension File.Response {
    /// 根据指定状态初始化操作结果
    ///
    /// 初始化失败结果时, 会自动生成错误描述并记录日志
    ///
    /// - Parameter status: 文件操作的执行状态
    private init(_ status: Status) {
        self.status = status
        if case .failed(let error, let url) = status {
            if #available(iOS 18.0, *) {
                FileConfiguration.logger?.log(error, url: url)
            }
        }
    }

    /// 创建一个成功的文件操作结果
    static var success: Self {
        Self(.success)
    }

    /// 创建一个失败的文件操作结果
    ///
    /// 创建时会自动记录错误日志，包含错误描述及相关文件路径
    ///
    /// - Parameters:
    ///   - error: 操作过程中发生的错误
    ///   - url: 与错误相关的文件 URL，默认为 `nil`
    ///
    /// - Returns: 表示操作失败的结果实例
    static func failed(_ error: Error, _ url: URL? = nil) -> Self {
        Self(.failed(error, url))
    }
}

/// 文件操作结果的状态查询
extension File.Response {
    /// 判断文件操作是否成功
    ///
    /// - Returns: 如果操作状态为 `.success`，则返回 `true`，否则返回 `false`
    var isSuccess: Bool {
        if case .success = status {
            return true
        }
        return false
    }
}
