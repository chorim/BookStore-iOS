//
//  ListLoadingCell.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/07.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit

class ListLoadingCell: UITableViewCell {
  
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicatorView.stopAnimating()
  }
  
}
