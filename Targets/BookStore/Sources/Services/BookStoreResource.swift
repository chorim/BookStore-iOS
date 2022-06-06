//
//  BookStoreResource.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/02.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

enum BookStoreResource {
  case search(String, Int?)
  case new
  case books(String)
}

// MARK: Resource
extension BookStoreResource: URLResource {
  var baseURL: URL {
    return URL(string: "https://api.itbook.store/1.0")!
  }
  
  var endpoint: String {
    switch self {
    case .search(let query, let page):
      if let page = page {
        return "/search/\(query)/\(page)"
      } else {
        return "/search/\(query)"
      }
    case .new:
      return "/new"
    case .books(let isbn13):
      return "/books/\(isbn13)"
    }
  }
  
  var method: APIClient.Method {
    switch self {
    case .search(_, _):
      return .get
    case .new:
      return .get
    case .books(_):
      return .get
    }
  }
  
  var headers: [String : String] {
    return [:]
  }
}
