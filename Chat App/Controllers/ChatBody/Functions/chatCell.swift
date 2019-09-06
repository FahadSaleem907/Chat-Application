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
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66)
            ])
        
        bubbleView.addSubview(bubbleView.timeLbl)
        
        NSLayoutConstraint.activate([
            bubbleView.timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0),
            bubbleView.timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),
            //            bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 10)
            ])
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
        
        if message.message!.count < 11 && bubbleView.isIncoming == true
        {
            NSLayoutConstraint.activate([
                bubbleView.timeLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
                bubbleView.timeLbl.leadingAnchor.constraint(equalTo: bubbleView.chatLbl.leadingAnchor, constant: (CGFloat(message.message!.count * 10)+20)),
                bubbleView.chatLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                bubbleView.chatLbl.topAnchor.constraint(equalTo: topAnchor, constant: 30)
                ])
        }
        else if message.message!.count < 11 && bubbleView.isIncoming == false
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
            //bubbleView.chatLbl.backgroundColor = color1
            //            bubbleView.bubbleLayer.fillColor = color1.cgColor
        }
        else
        {
            leadingOrTrailingConstraints = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0)
            //bubbleView.chatLbl.backgroundColor = color2
            //            bubbleView.bubbleLayer.fillColor = color2.cgColor
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

