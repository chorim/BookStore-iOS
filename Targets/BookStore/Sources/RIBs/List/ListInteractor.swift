//
//  ListInteractor.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift

protocol ListRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
  func attachSearchController()
}

protocol ListPresentable: Presentable {
  var listener: ListPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
  func updateUI(_ bookList: BookList)
  func updateUI(error: Error)
}

protocol ListListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ListInteractor: PresentableInteractor<ListPresentable>, ListInteractable, ListPresentableListener {
  
  weak var router: ListRouting?
  weak var listener: ListListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: ListPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    router?.attachSearchController()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  // MARK: ListPresentableListener
  func fetchBooks(_ page: Int?) async {
    do {
      var parameters: [String: Any] = [:]
      if let page = page {
        parameters["page"] = page
      }
      
      let bookList = try await APIClient.shared.request(BookStoreResource.new,
                                                        parameters: parameters,
                                                        model: BookList.self)
      presenter.updateUI(bookList)
    } catch let error {
      presenter.updateUI(error: error)
    }
  }
}
