//
//  DiskCache.swift
//  BookStoreUI
//
//  Created by Insu Byeon on 2022/10/10.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit

public class DiskCacheProvider {
  
  private let cacheFolderURL: URL?
  
  private let name: String
  private let countLimit: Int
  private let sizeLimit: Int
  private let fileManager: FileManager
  
  public init(name: String,
              countLimit: Int = 100,
              sizeLimit: Int = 1024 * 1024 * 1024,
              fileManager: FileManager = .default) {
    self.name = name
    self.countLimit = countLimit
    self.sizeLimit = sizeLimit
    self.fileManager = fileManager
    self.cacheFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
      .first?
      .appendingPathComponent(name)
    
    precondition(cacheFolderURL != nil, "DiskCache Folder URL Invalid")
    
    configureCacheFolder()
  }
  
  
  private func configureCacheFolder() {
    if let cacheFolderURL {
      guard !fileManager.fileExists(atPath: cacheFolderURL.path) else { return }
      do {
        try fileManager.createDirectory(at: cacheFolderURL,
                                        withIntermediateDirectories: true)
      } catch let error {
        print("Cannot create cache directory on \(cacheFolderURL), error : \(error)")
      }
    }
  }
}

// MARK: - Entry
extension DiskCacheProvider {
  public struct Entry {
    public let url: URL
    public let meta: URLResourceValues
    
    public init?(url: URL?, meta: URLResourceValues?) {
      guard let url = url, let meta = meta else { return nil }
      self.url = url
      self.meta = meta
    }
  }
}
