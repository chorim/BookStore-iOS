//
//  AppComponent+Root.swift
//  BookStoreUI
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs

final class AppComponent: Component<EmptyComponent> {
  convenience init() {
    self.init(dependency: EmptyComponent())
  }
}

extension AppComponent: RootDependency {

    // TODO: Implement properties to provide for Root scope.
}
