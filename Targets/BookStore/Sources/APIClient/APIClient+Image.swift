//
//  APIClient+Image.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/06.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation
import UIKit

extension APIClient {
  func requestImage(_ imageUrl: String) async throws -> Data? {
    guard let imageURL = URL(string: imageUrl) else {
      throw URLError(.badURL)
    }
    
    let (data, _) = try await session.data(from: imageURL)
    return data
  }
}

extension UIImageView {
  func setImage(_ remoteUrl: String) {
    Task.detached(priority: .utility) {
      try Task.checkCancellation()
      let data = try await APIClient.shared.requestImage(remoteUrl)
      try Task.checkCancellation()
      await self.setImage(data)
    }
  }
  
  @MainActor
  func setImage(_ data: Data?) {
    if let data = data {
      self.image = UIImage(data: data, scale: 0.75)
    }
  }
  
  func cancel() {}
}
