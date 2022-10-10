//
//  MemoryCache.swift
//  BookStoreUI
//
//  Created by Insu Byeon on 2022/10/10.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit

// MARK: MemoryCacheProvider
public class MemoryCacheProvider {
  
  private let cache = NSCache<NSString, NSData>()
  
  public static let `default` = MemoryCacheProvider(name: "default.cache.from.memory")
  
  public init(name: String,
              countLimit: Int = 100,
              totalCostLimit: Int = 100) {
    cache.name = name
    cache.countLimit = countLimit
    cache.totalCostLimit = totalCostLimit
  }
  
  subscript(_ key: String) -> Data? {
    get {
      guard let data = get(key: key) else { return nil }
      return Data(referencing: data)
    }
    set {
      if let data = newValue {
        put(key, data: data)
      } else {
        remove(key: key)
      }
    }
  }
  
  public func put(_ key: String, data: Data, cost: Int = 1) {
    cache.setObject(NSData(data: data),
                    forKey: key as NSString,
                    cost: cost)
  }
  
  public func get(key: String) -> NSData? {
    return cache.object(forKey: key as NSString)
  }
  
  public func remove(key: String) {
    cache.removeObject(forKey: key as NSString)
  }
}
