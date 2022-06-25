//
//  SearchResultsViewController.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/11.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol SearchResultsPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
  
  var searchBooks: PublishSubject<(String?, Int?)> { get }
}

final class SearchResultsViewController: UIViewController, SearchResultsPresentable, SearchResultsViewControllable {

  typealias Section = Int
  typealias Item = Book
  typealias DataSource = UITableViewDiffableDataSource<Section, Item>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  
  weak var listener: SearchResultsPresentableListener?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  private var task: Task<(), Never>?
  private var page: Int = 1
  
  private var books: [Book] = []
  private var dataSource: DataSource!
  private var snapshot = Snapshot()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let task = task, !task.isCancelled {
      task.cancel()
    }
  }
  
  func updateUI(_ bookList: BookList) {
    activityIndicatorView.stopAnimating()
    books = bookList.books
    
    snapshot.deleteAllItems()
    tableView.setContentOffset(.zero, animated: false)
    
    snapshot.appendSections([0])
    snapshot.appendItems(books)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateUI(error: Error) {
    activityIndicatorView.stopAnimating()
    tableView.setContentOffset(.zero, animated: false)
    Logger.error("Search books occurred error \(error.localizedDescription)")
  }
}

private extension SearchResultsViewController {
  func setupUI() {
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.register(UINib(nibName: "ListBookCell", bundle: Bundle.module),
                       forCellReuseIdentifier: "ListBookCell")
    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListBookCell",
                                               for: indexPath) as! ListBookCell
      cell.setupUI(item)
      
      return cell
    })
    tableView.dataSource = dataSource
  }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    Logger.info("Search button did clicked")
    activityIndicatorView.startAnimating()
    listener?.searchBooks.onNext((searchBar.text, nil))
  }
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    Logger.info("textDidChage \(searchText)")
    activityIndicatorView.startAnimating()
    listener?.searchBooks.onNext((searchText, nil))
  }
}
