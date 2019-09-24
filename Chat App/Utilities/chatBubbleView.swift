import Foundation
import UIKit

class ChatBubbleView :UIView
{
    let bubbleLayer = CAShapeLayer()
    
    
    let chatLbl : UILabel = {
        let msg = UILabel()
        msg.translatesAutoresizingMaskIntoConstraints = false
        msg.numberOfLines   = 0
        msg.text    = "Sample text"
        return msg
    }()
    
    let dateLbl : UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.numberOfLines = 1
        date.text = "20-12-2019"
        date.font = UIFont(name: "Avenir", size: 10)
        return date
    }()
    
    let timeLbl : UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.numberOfLines = 1
        time.font = UIFont(name: "Avenir", size: 10)
        return time
    }()
    
    let imgView: UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 15
        return img
    }()
    
    let toggleButton : UIButton = {
        let recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        //recordButton.setImage(UIImage(named: "Play"), for: .normal)
        recordButton.imageView?.contentMode = .scaleToFill
        recordButton.setTitle("", for: .normal)
        
        return recordButton
    }()
    
    var isIncoming = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()->Void
    {
        layer.addSublayer(bubbleLayer)
        addSubview(dateLbl)
        addSubview(chatLbl)
        addSubview(imgView)
        addSubview(toggleButton)
        chatLbl.addSubview(timeLbl)
        
        NSLayoutConstraint.activate([
            chatLbl.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            chatLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22.0),
            chatLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            chatLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0)
            ])
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22.0),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0)
            ])
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let height  = bounds.size.height
        let width   = bounds.size.width
        
        let bezierPath  = UIBezierPath()
        
        if isIncoming
        {
            bezierPath.move(to: CGPoint(x: 22, y: height))
            bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
            bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
            bezierPath.addLine(to: CGPoint(x: width, y: 17))
            bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
            bezierPath.addLine(to: CGPoint(x: 21, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
            bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
            bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
            bezierPath.close()
        }
        else
        {
            bezierPath.move(to: CGPoint(x: width - 22, y: height))
            bezierPath.addLine(to: CGPoint(x: 17, y: height))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
            bezierPath.addLine(to: CGPoint(x: 0, y: 17))
            bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
            bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
            bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
            bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
            bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
            bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
            bezierPath.close()
        }
        
        bubbleLayer.fillColor = isIncoming ? UIColor(white: 0.90, alpha: 1.0).cgColor : UIColor.green.cgColor
        
        bubbleLayer.path = bezierPath.cgPath
    }
    
    
}

