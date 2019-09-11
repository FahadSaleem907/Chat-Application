//
//  loadingCell.swift
//  Chat App
//
//  Created by Fahad Saleem on 9/11/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import UIKit

class loadingCell: UITableViewCell {

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
