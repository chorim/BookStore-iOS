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
  
  func updateResultsUI(_ bookList: BookList)
  func updateResultsUI(contentsOf bookList: BookList)
  func updateResultsUI(error: Error)
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
    bind()
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  // MARK: - SearchResultsListener
  var searchBooks: PublishSubject<(String?, Int?)> = PublishSubject<(String?, Int?)>()
}

private extension SearchInteractor {
  func bind() {
    // SearchResults RIB에서 검색 작업을 위임받음
    searchBooks
      .flatMap { (query, page) -> Observable<Result<(BookList, Int?), Error>> in
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
        .map { .success(($0, page)) }
        .catch { .just(.failure($0)) }
      }
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] result in
        // 작업은 SearchInteractor가 담당하지만
        // 화면에 결과 표시는 SearchResults로 다시 던져야함
        switch result {
        case .success((let bookList, let page)):
          if let page = page, page > 1 {
            self?.router?.updateResultsUI(contentsOf: bookList)
          } else {
            self?.router?.updateResultsUI(bookList)
          }
        case .failure(let error):
          self?.router?.updateResultsUI(error: error)
        }
      })
      .disposeOnDeactivate(interactor: self)
  }
}
