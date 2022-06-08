//
//  ListRouter.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs

protocol ListInteractable: Interactable, SearchListener {
  var router: ListRouting? { get set }
  var listener: ListListener? { get set }
}

protocol ListViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ListRouter: ViewableRouter<ListInteractable, ListViewControllable>, ListRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: ListInteractable,
       viewController: ListViewControllable,
       searchBuilder: SearchBuildable) {
    self.searchBuilder = searchBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSearchController() {
    let searchRouting = searchBuilder.build(withListener: interactor)
    attachChild(searchRouting)
  }
  
  // MARK: - Private
  private let searchBuilder: SearchBuildable
  private var searchRouting: SearchRouting?
}
