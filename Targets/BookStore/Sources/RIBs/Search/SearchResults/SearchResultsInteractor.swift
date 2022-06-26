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
  func updateUI(_ bookList: BookList)
  func updateUI(contentsOf bookList: BookList)
  func updateUI(error: Error)
  
  var isSearching: Bool { get set }
}

protocol SearchResultsListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  var searchBooks: PublishSubject<(String?, Int?)> { get }
}

final class SearchResultsInteractor: PresentableInteractor<SearchResultsPresentable>, SearchResultsInteractable, SearchResultsPresentableListener {
  
  weak var router: SearchResultsRouting?
  weak var listener: SearchResultsListener?
  
  var searchBooks: PublishSubject<(String?, Int?)> = PublishSubject<(String?, Int?)>()
  
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
    
    bind()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}

private extension SearchResultsInteractor {
  func bind() {
    searchBooks
      .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
      .filter { $0.0 != nil && ($0.0?.count ?? 0) > 2 }
      .subscribe(onNext: { [weak self] (query, page) in
        // 실제로 검색을 실행하는 RIB으로 작업을 위임함
        self?.presenter.isSearching = true
        self?.listener?.searchBooks.onNext((query, page))
      })
      .disposeOnDeactivate(interactor: self)
  }
}
