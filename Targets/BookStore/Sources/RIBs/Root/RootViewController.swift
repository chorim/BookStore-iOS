//
//  RootViewController.swift
//  BookStoreUI
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
  
  weak var listener: RootPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Root RIB has been attached")
  }
  
  // MARK: RootViewControllable
  func present(_ viewController: ViewControllable, animated: Bool) {
    viewController.uiviewController.modalPresentationStyle = .overFullScreen
    super.present(viewController.uiviewController, animated: animated)
  }
}
