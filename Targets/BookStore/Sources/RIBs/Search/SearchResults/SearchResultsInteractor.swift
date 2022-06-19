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
  func updateUI(error: Error)
}

protocol SearchResultsListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
      .distinctUntilChanged(at: \.0)
      .flatMap { (query, page) -> Observable<Result<BookList, Error>> in
        return AsyncThrowingStream<BookList, Error> { continuation in
          Task {
            if let query = query {
              do {
                let resource = BookStoreResource.search(query, page)
                let bookList = try await APIClient.shared.request(resource,
                                                                  model: BookList.self)
                continuation.yield(bookList)
                continuation.finish()
              } catch let error {
                continuation.finish(throwing: error)
              }
            }
          }
        }
        .asObservable()
        .map { .success($0) }
        .catch { .just(.failure($0)) }
      }
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] result in
        switch result {
        case .success(let bookList):
          self?.presenter.updateUI(bookList)
        case .failure(let error):
          self?.presenter.updateUI(error: error)
        }
      })
      .disposeOnDeactivate(interactor: self)
  }
}
