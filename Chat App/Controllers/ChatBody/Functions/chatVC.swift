import UIKit
import GrowingTextView
import IQKeyboardManager
import FirebaseFirestore

class chatVC: UIViewController
{
    //MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let conversationService = conversationFunctions()
    
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
    
    // MARK: -Variables
    var receiverID:String?
    var conversationID:String?
    var users:[String?] = []
    
    
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
    
    func getConvoID(completion:@escaping(String)->Void)
    {
        if users.count != nil
        {
            conversationService.getConversationID(users: users as! [String])
            {
                (id, err, userCount, convoCount) in
                guard let id = id
                    else
                {
                    print(err)
                    return
                }
                
                self.conversationID = id
                completion(self.conversationID!)
                
//                if userCount! > convoCount!
//                {
//                    self.createConversation(completion:
//                        {
//                            (id) in
//                            print(id)
//                        })
//                }
//                else
//                {
//                    self.conversationID = id
//                    completion(self.conversationID!)
//                }
            }
        }
    }
    
    func createConversation(completion:@escaping(String)->Void)
    {
        if users.count != nil
        {
            let convo1 = Conversation(conversationID: "asd", dateCreated: "12321", users: users as! [String])

            conversationService.createConversation(conversation: convo1)
            {
                (convo, success, error) in
                if error != nil
                {
                    print(error)
                }
                else
                {
                    self.conversationID = convo?.conversationID
                    print(self.conversationID)
                }
            }
        }
    }
    
    func handleCurrentUser()
    {
        if users.contains(delegate.currentUser!.uid) == true
        {
            return
        }
        else
        {
            users.append(delegate.currentUser!.uid)
        }
    }
    
    func handleOtherUsers()
    {
        if users.contains(receiverID!) == true
        {
            return
        }
        else
        {
            users.append(receiverID!)
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
        tabBarController?.tabBar.isHidden = true
        handleCurrentUser()
        handleOtherUsers()
        
        //createConversation()
        getConvoID
            {
                (id) in
                
                print(id)
            }
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
