//
//  APIClient+URLRequest.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/01.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

extension URLRequest {
  init(resource: URLResource, _ parameters: APIClient.Parameters) {
    var url = resource.baseURL.appendingPathComponent(resource.endpoint)
    let encoding = URLEncoding()
    
    if resource.method == .get {
      url = url.appendingQueryParameters(parameters, encoding: encoding)
    }

    self.init(url: url)
    
    httpMethod = resource.method.rawValue
    
    for (key, value) in resource.headers {
      addValue(value, forHTTPHeaderField: key)
    }
    
    if resource.method == .post || resource.method == .put {
      httpBody = encoding.query(parameters).data(using: .utf8)
    }
  }
}
