//
//  File.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Foundation

/// 文件管理工具集合
///
/// 提供文件管理相关的默认实例和错误类型别名, 便于统一访问文件系统操作及其错误处理
public enum File {
    /// Foundation 提供的默认文件管理器实例
    ///
    /// 用于执行文件和目录的创建、读取、移动、复制及删除等操作
    nonisolated(unsafe) static let Manager = FileManager.default

    /// 文件操作错误类型
    typealias E = File.FileError
}

public extension File {
    /// 检查指定路径是否存在。
    ///
    /// 用于判断指定 URL 对应的文件或目录是否存在
    ///
    /// - Parameter url: 待检查的文件或目录 URL
    ///
    /// - Returns: 如果路径存在则返回 `true`，否则返回 `false`
    static func check(_ url: URL) -> Bool {
        Manager.fileExists(atPath: url.path)
    }

    /// 检查指定路径是否为文件
    ///
    /// 通过文件系统判断路径是否存在且不是目录
    ///
    /// - Parameter url: 待检查的文件 URL
    ///
    /// - Returns: 如果路径存在且对应普通文件，则返回 `true`，否则返回 `false`
    static func isFile(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = Manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && !isDirectory.boolValue
    }

    /// 检查指定路径是否为目录
    ///
    /// 通过文件系统判断路径是否存在且为目录
    ///
    /// - Parameter url: 待检查的目录 URL
    ///
    /// - Returns: 如果路径存在且对应目录，则返回 `true`，否则返回 `false`
    static func isDirectory(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = Manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

public extension File {
    /// 在指定路径创建目录
    ///
    /// 如果目标目录不存在，则自动创建目录及其所有必要的中间目录
    /// 如果目录已经存在，则不会重复创建
    ///
    /// - Parameter directory: 需要创建的目录 URL
    ///
    /// - Returns: 文件操作结果
    ///   - `.success`: 目录创建成功或目录已存在
    ///   - `.failed`: 创建目录过程中发生错误，并返回错误信息及对应 URL
    static func create(path directory: URL) -> File.Response {
        do {
            if !File.isDirectory(directory) {
                try Manager.createDirectory(at: directory, withIntermediateDirectories: true)
            }
            return .success
        } catch {
            return .failed(error, directory)
        }
    }

    /// 将数据写入指定文件
    ///
    /// 写入前会自动创建目标文件所在的父目录
    /// 支持控制是否覆盖已经存在的文件，并使用原子写入方式保证文件写入的完整性
    ///
    /// - Parameters:
    ///   - data: 需要写入文件的数据
    ///   - url: 目标文件 URL
    ///   - overwrite: 是否允许覆盖已存在的文件，默认为 `true`
    ///
    /// - Returns: 文件操作结果
    ///   - `.success`: 数据写入成功
    ///   - `.failed`: 写入过程中发生错误，并返回错误信息及对应 URL
    ///
    /// - Note:
    ///   - 如果父目录不存在，会自动创建
    ///   - 当 `overwrite` 为 `false` 且目标文件已存在时，返回文件已存在错误
    ///   - 使用 `.atomic` 选项执行原子写入，避免写入过程中产生不完整文件
    static func write(_ data: Data, to url: URL, overwrite: Bool = true) -> File.Response {
        let response = File.create(path: url.deletingLastPathComponent())
        guard response.isSuccess else {
            return response
        }
        do {
            if !overwrite, Manager.fileExists(atPath: url.path) {
                return .failed(E.fileExistsAndNotAllowdOverwite, url)
            }
            try data.write(to: url, options: .atomic)
            return .success
        } catch {
            return .failed(error, url)
        }
    }
}

public extension File {
    /// 删除指定路径的文件或目录
    ///
    /// 删除前会检查 URL 是否有效以及目标路径是否存在
    /// 如果目标路径不存在，则返回对应错误
    ///
    /// - Parameter url: 需要删除的文件或目录 URL，可以为 `nil`
    ///
    /// - Returns: 文件操作结果
    ///   - `.success`: 文件或目录删除成功
    ///   - `.failed`: 删除过程中发生错误，并返回错误信息及对应 URL
    ///
    /// - Note:
    ///   - 如果 URL 为 `nil`，返回参数错误
    ///   - 如果目标路径不存在，返回路径不存在相关错误
    ///   - 支持删除文件及目录
    static func delete(path url: URL?) -> File.Response {
        guard let url = url else {
            return .failed(E.parameterError)
        }
        guard File.check(url) else {
            return .failed(E.notFound, url)
        }
        do {
            try Manager.removeItem(at: url)
            return .success
        } catch {
            return .failed(error, url)
        }
    }
}
