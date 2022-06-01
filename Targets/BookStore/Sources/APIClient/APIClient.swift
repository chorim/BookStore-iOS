//
//  APIClient.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/01.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

final class APIClient {
  typealias Parameters = [String: Any]
  
  private(set) var session: URLSession = {
    let session = URLSession.shared
    return session
  }()
  
  let decoder: JSONDecoder = JSONDecoder()
  
  static let shared = APIClient()
  
  private init() {}
}
