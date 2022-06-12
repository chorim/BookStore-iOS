//
//  SearchResultsRouter.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/11.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs

protocol SearchResultsInteractable: Interactable {
  var router: SearchResultsRouting? { get set }
  var listener: SearchResultsListener? { get set }
}

protocol SearchResultsViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchResultsRouter: ViewableRouter<SearchResultsInteractable, SearchResultsViewControllable>, SearchResultsRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: SearchResultsInteractable, viewController: SearchResultsViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
