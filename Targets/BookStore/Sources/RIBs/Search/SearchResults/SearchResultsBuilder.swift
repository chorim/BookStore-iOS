//
//  SearchResultsBuilder.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/11.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs

protocol SearchResultsDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class SearchResultsComponent: Component<SearchResultsDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchResultsBuildable: Buildable {
  func build(withListener listener: SearchResultsListener) -> SearchResultsRouting
}

final class SearchResultsBuilder: Builder<SearchResultsDependency>, SearchResultsBuildable {
  
  override init(dependency: SearchResultsDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchResultsListener) -> SearchResultsRouting {
    let component = SearchResultsComponent(dependency: dependency)
    let viewController = SearchResultsViewController()
    let interactor = SearchResultsInteractor(presenter: viewController)
    interactor.listener = listener
    return SearchResultsRouter(interactor: interactor, viewController: viewController)
  }
}
