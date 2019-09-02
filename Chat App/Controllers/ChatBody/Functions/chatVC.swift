import UIKit
import GrowingTextView
import IQKeyboardManager

class chatVC: UIViewController
{
    //MARK: - Constants
    let tmpArray = ["A short message.",
                    "A medium length message, longer than short.",
                    "A long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content.",
                    "Another short message.",
                    "Another medium length message, longer than short.",
                    "Another long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content."
    ]
    
    let theData: [Message] = [
        
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: false, message: "A short message."),
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: true, message: "A medium length message, longer than short."),
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: false, message: "A long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content."),
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: true, message: "Another short message."),
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: false, message: "Another medium length message, longer than short."),
        Message(msgid: nil,uid: nil,dateTime: nil , date: nil, time: nil, conversationID: nil, incoming: true, message: "Another long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content.")
    ]
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var chat: UITableView!
    @IBOutlet weak var typedMsgView: UIView!
    @IBOutlet weak var msgTxt: GrowingTextView!
    
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var gallery: UIButton!
    
    
    //MARK: - Functions
    func handleButton()
    {
        if msgTxt.text.isEmpty == true
        {
            mic.isHidden = false
            gallery.setImage(UIImage(named: "gallery"), for: .normal)
        }
        else
        {
            mic.isHidden = true
            gallery.setImage(UIImage(named: "send"), for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        typedMsgView.layer.cornerRadius = 20
        typedMsgView.layer.borderWidth = 2
        typedMsgView.layer.borderColor = UIColor.gray.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chat.delegate   = self
        chat.dataSource = self
        
        msgTxt.delegate = self

        // Do any additional setup after loading the view.
        
        chat.register(chatCell.self, forCellReuseIdentifier: "cell")
    }
}

extension chatVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chat.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! chatCell
        cell.setData(theData[indexPath.row])
        cell.contentView.backgroundColor = UIColor.clear
        chat.backgroundColor = UIColor.clear
        cell.bubbleView.backgroundColor = UIColor.clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return theData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = chat.cellForRow(at: indexPath) as! chatCell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = chat.cellForRow(at: indexPath) as! chatCell
    }
}

extension chatVC: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        handleButton()
    }
}
