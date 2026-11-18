//
//  Path.swift
//  FileKit
//
//  Created by NullSilck on 2026/11/18.
//

import Foundation

/// 文件系统路径管理命名空间
///
/// 集中提供应用程序沙盒中的常用目录路径, 便于统一访问和管理文件存储位置
public extension File {
    enum Path {}
}

public extension File.Path {
    // 应用程序支持目录
    //
    // 返回当前应用程序在用户沙盒中的 Application Support 目录
    //
    // 该目录适合存储应用程序运行所需的数据、配置文件及其他支持性文件
    //
    // - Returns: Application Support 目录的 URL
    //
    // - Important:
    //   - 如果无法获取目录 URL，会记录错误日志并触发 `fatalError`
    //   - 该属性仅返回目录路径，不会自动创建目录

    static var applicationSupportDirectory: URL {
        guard let url = File.Manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            let message = "Application Support directory not found"
            if #available(iOS 18.0, *) {
                FileConfiguration.logger?.log(message)
            }
            fatalError(message)
        }
        return url
    }
}
