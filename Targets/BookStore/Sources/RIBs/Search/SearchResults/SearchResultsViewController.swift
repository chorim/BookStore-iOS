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
}

final class SearchResultsViewController: UIViewController, SearchResultsPresentable, SearchResultsViewControllable {
  
  weak var listener: SearchResultsPresentableListener?
  
}
