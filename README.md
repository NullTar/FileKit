# FileKit

FileKit provides a simple and expressive interface for working with files and directories.

It aims to simplify common file operations while maintaining a clean API and allowing developers to customize logging behavior.

## Features

- File Management — Simplified file and directory operations.
- Path Management — Convenient path representation and manipulation through File.Path.
- Response Handling — Unified operation responses through File.Response.
- Custom Logging — Inject your own logging implementation using FileLogging.


## Swift Package Manager
Add this package to your `Package.swift`:

dependencies: [
    .package(url: "https://github.com/NullTar/FileKit.git")
]

Or add it in Xcode:
`File > Add Package Dependencies`
Paste repo url: `https://github.com/NullTar/FileKit.git`

## Logging

@available(iOS 18.0, *)

FileKit provides a customizable logging interface through the FileLogging protocol.

Instead of depending on a specific logging framework, FileKit allows developers to provide their own logging implementation.

### Implementing a Logger

Create a type that conforms to FileLogging:

```swift
import FileKit

struct MyLogger: FileLogging {

  /// Handle error logging
  static func log(_ error: Error, url: URL?) {     
  	let message = "Operation failed: \(error.localizedDescription)"
  		+ (url.map { ", on \($0.absoluteString)" } ?? "")
  	logger.error(message)
  }
  /// Handle general logging
  static func log(_ message: String) {
  	logger.info(message)
  }
}

```
### Injecting a Logger

Register your logging implementation during application initialization:

```swift
FileConfiguration.logger = MyLogger.self
```

FileKit will use the registered logger whenever logging is required.

You can integrate any logging framework by implementing the two methods provided by FileLogging.

## Usage

```swift
import FileKit
```

use File and File.Path to work with files and directories.

### File.Path

File.Path provides a dedicated representation of file system paths.

It is designed to make path handling more convenient and expressive.
```swift
/// - Returns: Application Support 目录的 URL
///
/// - Important:
///   - 如果无法获取目录 URL，会记录错误日志并触发 `fatalError`
///   - 该属性仅返回目录路径，不会自动创建目录
static var applicationSupportDirectory: URL
```
#### Use extension
```swift
extension File.Path {
    static let imagesPath: URL = Self.applicationSupportDirectory.appending(path: "images")
}
```

### File

File provides the main interface for file management operations.

#### Api
```swift
static func check(_ url: URL) -> Bool

static func isFile(_ url: URL) -> Bool

static func isDirectory(_ url: URL) -> Bool
```

```swift
static func create(path directory: URL) -> File.Response 

static func write(_ data: Data, to url: URL, overwrite: Bool = true) -> File.Response

static func delete(path url: URL?) -> File.Response
```

#### Use
```swift
/// receive File.Response
let response = File.create(path: url.deletingLastPathComponent())

guard File.write(data, to: pending.originalUrl, overwrite: false).isSuccess
else {
    return
}
```

### File.Response
1. success — The operation completed successfully.

2. failed(Error, URL?) — The operation failed, optionally providing the associated file URL.