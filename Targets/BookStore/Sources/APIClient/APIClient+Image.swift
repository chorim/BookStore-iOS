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
  func setImage(_ imageUrl: String) {
    Task.detached(priority: .utility) {
      try Task.checkCancellation()
      
      guard let imageURL = URL(string: imageUrl) else {
        throw URLError(.badURL)
      }
      
      let cacheKey = imageURL.lastPathComponent
      
      if let image = ImageCacheProvider.shared.get(key: cacheKey) {
        await self.setImage(image)
      } else {
        let image = try await APIClient.shared.requestImage(imageUrl)
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
  
  func cancel() {}
}

// MARK: ImageCacheProvider
final class ImageCacheProvider {
  private let cache = NSCache<NSString, UIImage>()
  private init() {}
  
  static let shared = ImageCacheProvider()
  
  func put(_ key: String, image: UIImage) {
    cache.setObject(image, forKey: key as NSString)
  }
  
  func get(key: String) -> UIImage? {
    return cache.object(forKey: key as NSString)
  }
}
