//
//  UINavigationController+RIBs.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit
import RIBs

extension UINavigationController: ViewControllable {
  public var uiviewController: UIViewController {
    return self
  }
  
  convenience init(viewControllable: ViewControllable) {
    self.init(rootViewController: viewControllable.uiviewController)
  }
}
