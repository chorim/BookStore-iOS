//
//  SearchRouter.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import UIKit

protocol SearchInteractable: Interactable, SearchResultsListener {
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
  init(interactor: SearchInteractable,
       viewController: SearchViewControllable,
       searchResultsBuilder: SearchResultsBuildable) {
    self.viewController = viewController
    self.searchResultsBuilder = searchResultsBuilder
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    // TODO: Since this router does not own its view, it needs to cleanup the views
    // it may have added to the view hierarchy, when its interactor is deactivated.
    guard let searchResultsRouting = searchResultsRouting else { return }
    
    self.searchResultsRouting = nil
    self.searchResultsViewController = nil
    detachChild(searchResultsRouting)
    
    viewController.setupSearchController(nil)
  }
  
  func setupViews() {
    guard searchResultsRouting == nil else { return }
    
    let searchResultsRouting = searchResultsBuilder.build(withListener: interactor)
    let searchResultsViewController = searchResultsRouting.viewControllable.uiviewController as? SearchResultsViewController
    attachChild(searchResultsRouting)
    
    assert(searchResultsViewController != nil, "Coudln't cast SearchResultsViewController")
    
    let searchController = UISearchController(searchResultsController: searchResultsViewController)
    searchController.searchBar.placeholder = "Search books"
    searchController.automaticallyShowsCancelButton = true
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = true
    searchController.searchBar.delegate = searchResultsViewController
    self.searchResultsViewController = searchResultsViewController
    
    viewController.setupSearchController(searchController)
  }
  
  func updateResultsUI(_ bookList: BookList) {
    assert(searchResultsViewController != nil, "The SearchResultsViewController has not been initialized")
    searchResultsViewController?.updateUI(bookList)
    searchResultsViewController?.isSearching = false
  }
  
  func updateResultsUI(error: Error) {
    assert(searchResultsViewController != nil, "The SearchResultsViewController has not been initialized")
    searchResultsViewController?.updateUI(error: error)
    searchResultsViewController?.isSearching = false
  }
  
  // MARK: - Private
  
  private let viewController: SearchViewControllable
  
  private let searchResultsBuilder: SearchResultsBuildable
  private var searchResultsRouting: ViewableRouting?
  private var searchResultsViewController: SearchResultsViewController?
}
