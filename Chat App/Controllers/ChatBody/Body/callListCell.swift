//
//  callListCell.swift
//  Chat App
//
//  Created by Fahad Saleem on 8/29/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import UIKit

class callListCell: UITableViewCell
{
    //MARK: -Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var callTypeImg: UIImageView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    //MARK: -Functions
    func roundedImg()
    {
        let height = img.frame.height
        img.layer.cornerRadius = height/2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedImg()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
