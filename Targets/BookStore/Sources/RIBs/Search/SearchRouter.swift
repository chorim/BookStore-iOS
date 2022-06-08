//
//  SearchRouter.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import UIKit

protocol SearchInteractable: Interactable {
  var router: SearchRouting? { get set }
  var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
  func setupSearchController(_ searchController: UISearchController?)
}

final class SearchRouter: Router<SearchInteractable>, SearchRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: SearchInteractable, viewController: SearchViewControllable) {
    self.viewController = viewController
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    // TODO: Since this router does not own its view, it needs to cleanup the views
    // it may have added to the view hierarchy, when its interactor is deactivated.
    viewController.setupSearchController(nil)
  }
  
  func setupViews() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.placeholder = "Search books"
    searchController.automaticallyShowsCancelButton = true
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = true
    viewController.setupSearchController(searchController)
  }
  // MARK: - Private
  
  private let viewController: SearchViewControllable
}
