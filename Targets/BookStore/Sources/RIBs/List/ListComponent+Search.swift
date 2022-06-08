//
//  ListComponent+Search.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of List to provide for the Search scope.
// TODO: Update ListDependency protocol to inherit this protocol.
protocol ListDependencySearch: Dependency {
  // TODO: Declare dependencies needed from the parent scope of List to provide dependencies
  // for the Search scope.
}

extension ListComponent: SearchDependency {
  // TODO: Implement properties to provide for Search scope.
  var searchViewController: SearchViewControllable {
    return listViewController
  }
}
