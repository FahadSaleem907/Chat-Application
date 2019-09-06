import UIKit
import GrowingTextView
import IQKeyboardManager
import FirebaseFirestore

class chatVC: UIViewController
{
    //MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let conversationService = conversationFunctions()
    let oneToOneConvoService = oneToOneConvoFunctions()
    let messageService = messageFunctions()
    let userService = userFunctions()
    
    
    // MARK: -Variables
    var receiverID:String?
    var conversationID:String?
    var dateAndTime:String?
    var dateOnly:String?
    var timeOnly:String?
    var users:[String?] = []
    {
        didSet
        {
            self.users.sort
                {
                    (a, b) -> Bool in
                    return a! < b!
                }
        }
    }
    var messages:[Message?] = []
    {
        didSet
        {
            if self.messages.count > 1
            {
                self.messages.sort
                    {
                        (a, b) -> Bool in
                        
                    let isoDateA = a?.dateTime
                    let isoDateB = b?.dateTime

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .medium
                    let dateA = dateFormatter.date(from: isoDateA!)
                    let dateB = dateFormatter.date(from: isoDateB!)
                        
                    return dateA! < dateB!
//                    dateFormatter.dateFormat = "dd-MM-yyyy HH:MM:SS"
//                    return a!.dateTime > b!.dateTime
                    }
            }
            //messageService.updateIncomingStatus(users: users, convoID: self.conversationID!, message: self.messages)
            chat.reloadData()
        }
    }
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var chat: UITableView!
    @IBOutlet weak var typedMsgView: UIView!
    @IBOutlet weak var msgTxt: GrowingTextView!
    
    @IBOutlet weak var noMsgTxt: UILabel!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var gallery: UIButton!
    
    //MARK: -Actions
    
    @IBAction func cameraBtn(_ sender: UIButton)
    {
        print("camera")
    }

    @IBAction func micBtn(_ sender: UIButton)
    {
        print("mic")
    }
    
    @IBAction func picOrSendBtn(_ sender: UIButton)
    {
        handleSendButton()
        
    }
    
    //MARK: - Functions
    func handleButton(){
        if msgTxt.text.isEmpty == true{
            mic.isHidden = false
            gallery.setImage(UIImage(named: "gallery"), for: .normal)
        }else{
            mic.isHidden = true
            gallery.setImage(UIImage(named: "send"), for: .normal)
        }
    }
    
    func handleSendButton()
    {
        if gallery.currentImage == UIImage(named: "gallery")
        {
            print("gallery")
        }
        else
        {
            sendMessage(conversationID: self.conversationID!)
            print("\(msgTxt.text!)")
            msgTxt.text = ""
            self.view.endEditing(true)
            handleButton()
        }
    }
    
    
    func getDateTime()
    {
        let dateTime = Date()
        let dateTimeFormat = DateFormatter()
        dateTimeFormat.dateStyle = .medium
        dateTimeFormat.timeStyle = .medium
        dateAndTime = dateTimeFormat.string(from: dateTime)
    }
    
    
    func getDate()
    {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .none
        dateOnly = dateFormat.string(from: date)
    }

    func getTime()
    {
        let time = Date()
        let timeFormat = DateFormatter()
        timeFormat.dateStyle = .none
        timeFormat.timeStyle = .medium
        timeOnly = timeFormat.string(from: time)
    }
    
    
//    func getMessages(userArr:[String?],completion:@escaping([Message?]?)->Void)
//    {
//        self.messageService.getMsgs(convoID: self.conversationID, users: userArr)
//        {
//            (msgArray, error) in
//            guard let msgArray = msgArray else
//            {
//                print("Error : \(error)")
//                completion(nil)
//                return
//            }
//
//            print(msgArray.count)
//            completion(msgArray)
//        }
//    }
    
    func createConvo(users:[String?],completion:@escaping(Bool,String?)->Void)
    {
        let convo1 = Conversation(conversationID: "\(users[0]!+users[1]!)", dateCreated: "123", users: users as! [String])
        
        oneToOneConvoService.createOneToOneConvo(conversation: convo1) { (convo, success, error) in
            if success == true{
                print("Convo created : \(convo?.conversationID)")
                self.userService.updateConversationList(convoID: convo?.conversationID, users: users)
                
                completion(true,convo?.conversationID)
            }else{
                print(error)
                completion(false,error)
            }
        }
    }
    
    
    func checkForExistance(completion:@escaping(Bool)->Void)
    {
        oneToOneConvoService.checkIfOneToOneConvoExists(users: users as! [String]) { (count) in
            
            if count != nil
            {
                print("ConvoExists")
                completion(true)
            }
            else
            {
                print("ConvoDoesNotExist")
                completion(false)
            }
        }
    }
    
    func sendMessage(conversationID:String)
    {
        getDateTime()
        getDate()
        getTime()
        
        let message1 = Message(msgid: "test", uid: delegate.currentUser!.uid!, dateTime: "\(dateAndTime!)", date: "\(dateOnly!)", time: "\(timeOnly!)", conversationID: self.conversationID, incoming: false, message: msgTxt.text)
            
        messageService.createMessage(message: message1, ConvoID: self.conversationID)
        {
            (message, success, error) in
            if success == true
            {
                print("Sent Successfully: \(message)")
            }
            else
            {
                print(error)
            }
        }
    }
    
    func getMsgs()
    {
        messageService.getOneToOneMsgs(convoID: self.conversationID!) { (messageArray, error) in
            guard let messageArray = messageArray else
            {
                print("Error: \(error!)")
                return
            }
            self.messages.removeAll()
            self.messages = messageArray
            print(self.messages.count)
        }
    }
    
//    func getConvoID(completion:@escaping(String)->Void)
//    {
//        if users.count != nil
//        {
//            conversationService.getConversationID(users: users as! [String])
//            {
//                (id, err, userCount, convoCount) in
//                guard let id = id
//                    else
//                {
//                    print(err)
//                    return
//                }
//
//                self.conversationID = id
//                completion(self.conversationID!)
//            }
//        }
//    }
//
//    func checkIfConvoExists()
//    {
//        users1 = users
//        conversationService.checkIfConvoExists(users: self.users1 as! [String])
//        {
//            (count) in
//            if count == nil
//            {
//                print("No Such Convo Exists")
//
//                let convo1 = Conversation(conversationID: "asd", dateCreated: "12321", users: self.users1 as! [String])
//
//                self.createConversation(completion:
//                    {
//                        (convoID) in
//                        print(convoID)
//                    })
//            }
//            else
//            {
//                print("Convo already exists")
//            }
//        }
//    }
//
//    func createConversation(completion:@escaping(String)->Void)
//    {
//        if users.count == 2
//        {
//            let convo1 = Conversation(conversationID: "asd", dateCreated: "12321", users: users as! [String])
//
//            conversationService.createConversation(conversation: convo1)
//            {
//                (convo, success, error) in
//                if error != nil
//                {
//                    print(error)
//                }
//                else
//                {
//                    self.conversationID = convo?.conversationID
//                    print(self.conversationID)
//
//                    self.userService.updateConversationList(convoID: self.conversationID, users: self.users1)
//                }
//            }
//        }
//        else
//        {
//
//        }
//    }
    
    func handleCurrentUser(){
        if users.contains(delegate.currentUser!.uid) == true{
            return
        }else{
            users.append(delegate.currentUser!.uid)
        }
    }
    
    func handleOtherUsers(){
        if users.contains(receiverID!) == true{
            return
        }else{
            users.append(receiverID!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews()
    {
        typedMsgView.layer.cornerRadius = 20
        typedMsgView.layer.borderWidth = 2
        typedMsgView.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        if users.isEmpty == true || users.count == 1
        {
            handleCurrentUser()
            handleOtherUsers()
            print(users)
        }
        
        
        checkForExistance
            {
                (success) in
                if success == true
                {
                    print("Enjoy")
                    self.getMsgs()
//                    self.messages = []
//                    self.getMessages(userArr: self.users, completion:
//                        {
//                            (msgArr) in
//                            guard let msgArr = msgArr else
//                            {
//                                print("No Messages")
//                                return
//                            }
//                            self.messages.removeAll()
//                            self.messages = msgArr
//                            print(msgArr.count)
//                    })
                }
                else
                {
                    self.createConvo(users: self.users, completion:
                        {
                            (success, result) in
                            if success == true
                            {
                                print("Convo Created")
                                self.conversationID = result
                                print("1:\(self.conversationID)")

                                self.getMsgs()
//                                self.messages = []
//
//                                self.getMessages(userArr: self.users, completion:
//                                    {
//                                        (msgArr) in
//                                        guard let msgArr = msgArr else
//                                        {
//                                            print("No Messages")
//                                            return
//                                        }
//                                        self.messages.removeAll()
//                                        self.messages = msgArr
//                                        print(msgArr.count)
//                                })
                            }
                            else
                            {
                                print("Failed to create Convo")
                            }
                        })
                }
            }

//        checkIfConvoExists()
//        createConversation()
//        getConvoID
//            {
//                (id) in
//
//                print(id)
//            }
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
        
        if messages.count == 0
        {
            noMsgTxt.isHidden = false
            chat.isHidden = true
        }
        else
        {
            noMsgTxt.isHidden = true
            chat.isHidden = false
            cell.setData(messages[indexPath.row]!)
//            chat.scrollToRow(at: indexPath, at: .bottom, animated: true)          
        }
        cell.contentView.backgroundColor = UIColor.clear
        chat.backgroundColor = UIColor.clear
        cell.bubbleView.backgroundColor = UIColor.clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
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
