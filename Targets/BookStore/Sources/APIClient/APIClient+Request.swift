//
//  APIClient+Request.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/01.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation

extension APIClient {
  func request<Model: Decodable>(_ resource: URLResource,
                                 parameters: Parameters,
                                 model: Model.Type) async throws -> Model {
    let urlRequest = URLRequest(resource: resource, parameters)
    let (data, _) = try await session.data(for: urlRequest)
    
    return try decoder.decode(Model.self, from: data)
  }
}
