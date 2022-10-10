//
//  APIClient+Image.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/06.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  enum Scale: CGFloat {
    case low = 0.25
    case medium = 0.50
    case high = 0.75
    case original = 1.0
  }
  
  convenience init?(data: Data, scale: Scale = .high) {
    self.init(data: data, scale: scale.rawValue)
  }
}

extension APIClient {
  func requestImage(_ imageUrl: String) async throws -> UIImage? {
    guard let imageURL = URL(string: imageUrl) else {
      throw URLError(.badURL)
    }
    
    let (data, _) = try await session.data(from: imageURL)
    return UIImage(data: data)
  }
}

extension UIImageView {
  func setImage(url: String) {
    task = Task.detached(priority: .background) {
      try Task.checkCancellation()
      
      guard let imageURL = URL(string: url) else {
        throw URLError(.badURL)
      }
      
      let cacheKey = imageURL.lastPathComponent

      if let image = ImageCacheProvider.shared.get(key: cacheKey) {
        try Task.checkCancellation()
        await self.setImage(image)
      } else {
        let image = try await APIClient.shared.requestImage(url)
        try Task.checkCancellation()
        await self.setImage(image)
        if let image = image {
          ImageCacheProvider.shared.put(cacheKey, image: image)
        }
      }
    }
  }
  
  @MainActor
  func setImage(_ image: UIImage?) {
    self.image = image
  }
  
  func cancel() {
    if let task {
      guard !task.isCancelled else { return }
      task.cancel()
    }
  }
}
