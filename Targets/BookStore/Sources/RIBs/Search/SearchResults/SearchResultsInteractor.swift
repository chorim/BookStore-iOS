//
//  SearchResultsInteractor.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/11.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift

protocol SearchResultsRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchResultsPresentable: Presentable {
  var listener: SearchResultsPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchResultsListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchResultsInteractor: PresentableInteractor<SearchResultsPresentable>, SearchResultsInteractable, SearchResultsPresentableListener {
  
  weak var router: SearchResultsRouting?
  weak var listener: SearchResultsListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: SearchResultsPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    Logger.debug("SearchResults RIB attached")
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
