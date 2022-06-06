//
//  BookList.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/02.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

// MARK: - BookList
struct BookList: Decodable {
  let total: String
  let page: String?
  let books: [Book]
}

// MARK: - Book
struct Book: Codable {
  let title, subtitle, isbn13, price: String
  let desc: String?
  let image: String
  let url: String
}

extension Book: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(title)
    hasher.combine(subtitle)
    hasher.combine(isbn13)
    hasher.combine(price)
    hasher.combine(desc)
    hasher.combine(image)
    hasher.combine(url)
  }
}
