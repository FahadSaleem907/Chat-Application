//
//  newMessageCell.swift
//  Chat App
//
//  Created by Fahad Saleem on 8/29/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import UIKit

class newMessageCell: UITableViewCell {

    //MARK: -Outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var status: UIImageView!
    
    //MARK: -Functions
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
