//
//  APIClient+URLResource.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/02.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

protocol URLResource {
  var baseURL: URL { get }
  var endpoint: String { get }
  var method: APIClient.Method { get }
  var headers: [String: String] { get }
}
