//
//  App.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/19.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation
import Logging

struct App {
  static let logger: Logging.Logger = {
    let bundleIdentifier = Bundle.module.bundleIdentifier ?? "com.apple.BookStore"
    let logger = Logging.Logger(label: "\(bundleIdentifier).main")
    return logger
  }()
}
