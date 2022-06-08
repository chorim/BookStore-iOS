//
//  RootRouter.swift
//  BookStoreUI
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, ListListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
  func present(_ viewController: ViewControllable, animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
  
  private let listBuilder: ListBuildable
  private var listRouting: ViewableRouting?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: RootInteractable,
       viewController: RootViewControllable,
       listBuilder: ListBuildable) {
    self.listBuilder = listBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  // MARK: RootRouting
  func routeToList() {
    let listRouting = listBuilder.build(withListener: interactor)
    self.listRouting = listRouting
    attachChild(listRouting)
    
    let navigationController = UINavigationController(viewControllable: listRouting.viewControllable)
    viewController.present(navigationController, animated: false)
  }
}
