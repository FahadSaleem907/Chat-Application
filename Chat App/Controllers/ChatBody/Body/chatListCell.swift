//
//  chatListCell.swift
//  Chat App
//
//  Created by Fahad Saleem on 8/29/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import UIKit

class chatListCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    func roundedImg()
    {
        let height = img.frame.height
        
        img.layer.cornerRadius = height/2
        img.layer.masksToBounds = true
        img.contentMode = .scaleToFill
        
        layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        roundedImg()
    }
    
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
