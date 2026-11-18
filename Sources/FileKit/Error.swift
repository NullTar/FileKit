//
//  Error.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Foundation

public extension File {
    enum FileError: LocalizedError {
        /// 参数无效或缺少必要参数
        case parameterError
        /// 目标文件已存在，且不允许覆盖
        case fileExistsAndNotAllowdOverwite
        /// 目标文件或目录不存在
        case notFound
    }
}

public extension File.FileError {
    /// 返回对应错误的描述信息
    ///
    /// 根据具体错误类型提供可读的错误说明
    ///
    /// - Returns: 当前错误对应的描述文本
    var errorDescription: String? {
        switch self {
        case .parameterError: "Invalid parameter"
        case .fileExistsAndNotAllowdOverwite: "File exists and not allowed overwite"
        case .notFound: "not found"
        }
    }
}
