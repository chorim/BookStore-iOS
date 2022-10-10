//
//  APIClient+ImageCache.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/10/10.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit

private var taskCachedKey: Void?

extension UIImageView {
  var task: Task<Void, any Error>? {
    get { objc_getAssociatedObject(self, &taskCachedKey) as? Task<Void, any Error> }
    set { objc_setAssociatedObject(self, &taskCachedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
}
