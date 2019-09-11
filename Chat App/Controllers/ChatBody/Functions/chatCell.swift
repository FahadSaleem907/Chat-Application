import UIKit

class chatCell: UITableViewCell
{
    //    @IBInspectable public var color1 = UIColor.green
    //    @IBInspectable public var color2 = UIColor.black
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let bubbleView:ChatBubbleView =
    {
        let bubble = ChatBubbleView()
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    var leadingOrTrailingConstraints = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(bubbleView.dateLbl)
        
        contentView.addSubview(bubbleView)
        
        NSLayoutConstraint.activate([
            bubbleView.dateLbl.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bubbleView.dateLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            bubbleView.dateLbl.bottomAnchor.constraint(equalTo: bubbleView.topAnchor, constant: -10),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30.0),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66),
            bubbleView.imgView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
            ])
        
        bubbleView.addSubview(bubbleView.timeLbl)
        
        NSLayoutConstraint.activate([
            bubbleView.timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0),
            bubbleView.timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),
            //            bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 10)
            ])
        
        bubbleView.addSubview(bubbleView.imgView)
        
//        if bubbleView.imgView.isHidden == false
//        {
//            bubbleView.chatLbl.isHidden = true
//        NSLayoutConstraint.activate([
//            bubbleView.imgView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 5),
//            bubbleView.imgView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
//            bubbleView.imgView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
//            bubbleView.imgView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 5),
//            bubbleView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.20)
//            ])
//        }
    }
    
    func setData1(_ message: Message) -> Void
    {
        bubbleView.dateLbl.text = "\(message.date!)"
        bubbleView.timeLbl.text = "\(message.time!)"
        bubbleView.chatLbl.text = message.message
        
        let url = message.message
        let imgURL = URL(string: url!)
        bubbleView.imgView.sd_setImage(with: imgURL, completed: nil)
        
        if message.uid == delegate.currentUser?.uid
        {
            bubbleView.isIncoming   = message.incoming!
        }
        else
        {
            bubbleView.isIncoming   = !message.incoming!
        }
        
        leadingOrTrailingConstraints.isActive = false
        
        if bubbleView.isIncoming == true
        {
            NSLayoutConstraint.activate([
                bubbleView.imgView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
                bubbleView.imgView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 22),
                bubbleView.imgView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
                bubbleView.imgView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 10),
                bubbleView.timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0)
                ])
//                bubbleView.timeLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
//                bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.chatLbl.leadingAnchor, constant: (CGFloat(message.message!.count * 10)+20)),
//                bubbleView.chatLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
//                bubbleView.chatLbl.topAnchor.constraint(equalTo: topAnchor, constant: 30)
//                ])
        }
        else if bubbleView.isIncoming == false
        {
            
            NSLayoutConstraint.activate([
                bubbleView.imgView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0),
                bubbleView.imgView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 22),
                bubbleView.imgView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 0),
                bubbleView.imgView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 0),
                bubbleView.timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0)
                ])
        }
        
        if delegate.currentUser?.uid == message.uid
        {
            leadingOrTrailingConstraints = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0)
        }
        else
        {
            leadingOrTrailingConstraints = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
        }
        
        leadingOrTrailingConstraints.isActive = true
    }
    
    func setData(_ message: Message) -> Void
    {
        bubbleView.dateLbl.text = "\(message.date!)"
        bubbleView.timeLbl.text = "\(message.time!)"
        bubbleView.chatLbl.text = message.message
        
        if message.uid == delegate.currentUser?.uid
        {
            bubbleView.isIncoming   = message.incoming!
        }
        else
        {
            bubbleView.isIncoming   = !message.incoming!
        }
        
        leadingOrTrailingConstraints.isActive = false
        
        if message.message!.count < 10 && bubbleView.isIncoming == true
        {
            bubbleView.chatLbl.numberOfLines = 1
            
            NSLayoutConstraint.activate([
                bubbleView.timeLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
                bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.chatLbl.leadingAnchor, constant: (CGFloat(message.message!.count * 10)+20)),
                bubbleView.chatLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                bubbleView.chatLbl.topAnchor.constraint(equalTo: topAnchor, constant: 30)
                ])
        }
        else if message.message!.count < 10 && bubbleView.isIncoming == false
        {
            NSLayoutConstraint.activate([
                bubbleView.timeLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
                bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.chatLbl.leadingAnchor, constant: (CGFloat(message.message!.count * 10)+20)),
                bubbleView.chatLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                bubbleView.chatLbl.topAnchor.constraint(equalTo: topAnchor, constant: 30)
                ])
        }
        
        if delegate.currentUser?.uid == message.uid
        {
            leadingOrTrailingConstraints = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0)
        }
        else
        {
            leadingOrTrailingConstraints = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
        }
        
        leadingOrTrailingConstraints.isActive = true
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

