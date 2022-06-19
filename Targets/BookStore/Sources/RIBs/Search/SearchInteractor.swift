//
//  SearchInteractor.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/08.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift

protocol SearchRouting: Routing {
  func cleanupViews()
  func setupViews()
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchInteractor: Interactor, SearchInteractable {
  
  weak var router: SearchRouting?
  weak var listener: SearchListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init() {}
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    Logger.debug("Search RIB attached")
    router?.setupViews()
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
}
