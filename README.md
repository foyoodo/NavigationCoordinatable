# NavigationCoordinatable

A simple, delightful implementation of the Coordinator pattern in SwiftUI, also compatible with UIKit. Inspired by **[Stinsen](https://github.com/rundfunk47/stinsen)**.

## What's different with [Stinsen](https://github.com/rundfunk47/stinsen)

In pure SwiftUI, it uses `NavigationStack` instead of `NavigationView`, which allows attaching future `NavigationStack` functionalities. Additionally, we can use navigation transitions like `zoom` on iOS 18+. We can also present a SwiftUI view in UIKit using `UIHostingController` without needing navigation-based handling.

## Requirements

- iOS 16.0 (or newer)
- macOS 13.0 (or newer)

## Installation

```
https://github.com/foyoodo/NavigationCoordinatable.git
```

In your `Package.swift`

```swift
.package(url: "https://github.com/foyoodo/NavigationCoordinatable.git", .branch("main"))
```
