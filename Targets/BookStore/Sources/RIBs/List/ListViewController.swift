//
//  ListViewController.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/05/30.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ListPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
  func fetchBooks(_ page: Int?) async
}

final class ListViewController: UIViewController, ListPresentable, ListViewControllable {
  typealias Section = Int
  typealias Item = Book
  typealias DataSource = UITableViewDiffableDataSource<Section, Item>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
  
  weak var listener: ListPresentableListener?
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    task = Task {
      await listener?.fetchBooks(page)
      
      activityIndicatorView.stopAnimating()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let task = task, !task.isCancelled {
      task.cancel()
    }
  }
  
  func updateUI(_ bookList: BookList) {
    self.books += bookList.books
    
    snapshot.appendItems(books)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func updateUI(error: Error) {
    let alertController = UIAlertController(title: "Error",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    let confirmButton = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(confirmButton)
    
    present(alertController, animated: true)
  }
}

private extension ListViewController {
  func setupUI() {
    title = "BookStore"
    
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.register(UINib(nibName: "ListBookCell", bundle: Bundle.main),
                       forCellReuseIdentifier: "ListBookCell")
    dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListBookCell",
                                               for: indexPath) as! ListBookCell
      cell.setupUI(item)
      
      return cell
    })
    tableView.dataSource = dataSource
    
    snapshot.appendSections([0])
  }
}

// MARK: SearchViewControllable
extension ListViewController: SearchViewControllable {
  func setupSearchController(_ searchController: UISearchController?) {
    navigationItem.searchController = searchController
  }
}
