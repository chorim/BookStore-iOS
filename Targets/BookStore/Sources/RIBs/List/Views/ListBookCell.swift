//
//  ListBookCell.swift
//  BookStore
//
//  Created by Insu Byeon on 2022/06/06.
//  Copyright © 2022 Insu Byeon. All rights reserved.
//

import UIKit

class ListBookCell: UITableViewCell {
  
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  
  private var task: Task<(), Never>?
  
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
    
    thumbImageView.cancel()
    
    Task { @MainActor in
      self.thumbImageView.setImage(nil)
      self.titleLabel.text = nil
      self.descLabel.text = nil
      self.descLabel.sizeToFit()
    }
  }
  
  func setupUI(_ book: Book) {
    Task { @MainActor in
      self.thumbImageView.setImage(url: book.image)
      self.titleLabel.text = book.title
      self.descLabel.text = book.subtitle
      self.descLabel.sizeToFit()
    }
  }
  
}
