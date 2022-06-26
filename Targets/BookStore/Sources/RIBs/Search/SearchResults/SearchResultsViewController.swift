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
  private var query: String? = nil {
    didSet {
      page = 1
      listener?.searchBooks.onNext((query, page))
    }
  }
  
  private var books: [Book] = []
  private var dataSource: DataSource!
  private var snapshot = Snapshot()
  
  var isSearching: Bool = false {
    didSet {
      if isSearching {
        activityIndicatorView.startAnimating()
        tableView.tableFooterView = nil
      } else {
        activityIndicatorView.stopAnimating()
        tableView.tableFooterView = books.count > 0 ? loadingCellView : nil
      }
    }
  }
  
  private lazy var loadingCellView: UIView? = {
    return UINib(nibName: "ListLoadingCell",
                 bundle: Bundle.module).instantiate(withOwner: self,
                                                    options: nil).first as? UIView
  }()
  
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
    books = bookList.books
    snapshot.deleteAllItems()
    tableView.setContentOffset(.zero, animated: false)
    
    snapshot.appendSections([0])
    snapshot.appendItems(books)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateUI(contentsOf bookList: BookList) {
    // append only
    books.append(contentsOf: bookList.books)
    page += 1
    snapshot.appendItems(bookList.books)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateUI(error: Error) {
    tableView.setContentOffset(.zero, animated: false)
    Logger.error("Search books occurred error \(error.localizedDescription)")
  }
}

private extension SearchResultsViewController {
  func setupUI() {
    tableView.estimatedRowHeight = UITableView.automaticDimension
    // TODO: Extension으로 따로 빼야하는데 귀찮음
    tableView.register(UINib(nibName: "ListBookCell", bundle: Bundle.module),
                       forCellReuseIdentifier: "ListBookCell")
    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListBookCell",
                                               for: indexPath) as! ListBookCell
      cell.setupUI(item)
      
      return cell
    })
    tableView.dataSource = dataSource
    tableView.delegate = self
  }
}

extension SearchResultsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if indexPath.row >= books.count - 2 {
      Logger.info("Next page fetch need : \(String(describing: query)) \(page)")
      listener?.searchBooks.onNext((query, page + 1))
    }
  }
}

// MARK: - UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    Logger.info("Search button did clicked")
    query = searchBar.text
  }
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    Logger.info("textDidChage \(searchText)")
    query = searchText
  }
}
