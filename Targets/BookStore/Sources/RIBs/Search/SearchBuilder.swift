//
//  SearchBuilder.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import UIKit

protocol SearchDependency: Dependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  var searchViewController: SearchViewControllable { get }
  // TODO: Declare the set of dependencies required by this RIB, but won't be
  // created by this RIB.
}

final class SearchComponent: Component<SearchDependency> {
  
  // TODO: Make sure to convert the variable into lower-camelcase.
  fileprivate var searchViewController: SearchViewControllable {
    return dependency.searchViewController
  }
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchBuildable: Buildable {
  func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {
  
  override init(dependency: SearchDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchListener) -> SearchRouting {
    let component = SearchComponent(dependency: dependency)
    let interactor = SearchInteractor()
    interactor.listener = listener
    return SearchRouter(interactor: interactor, viewController: component.searchViewController)
  }
}
