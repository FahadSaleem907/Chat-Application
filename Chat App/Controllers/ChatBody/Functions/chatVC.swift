import UIKit
import GrowingTextView
import IQKeyboardManager
import FirebaseFirestore
import YPImagePicker

class chatVC: UIViewController
{
    //MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let conversationService = conversationFunctions()
    let oneToOneConvoServices = oneToOneConvoFunctions()
    let messageService = messageFunctions()
    let userService = userFunctions()
    let imgType = signUpVC()
    
    
    // MARK: -Variables
    var receiverID:String?
    var conversationID:String?
    var selectedImage:UIImage?
    var getMoreData = false
    var dateAndTime:String?
    var dateOnly:String?
    var timeOnly:String?
    var msgImg:UIImage?
    var msgImgURL:String?
    var otherUser:User?
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
            self.view.layoutIfNeeded()

//            DispatchQueue.main.async
//            {
//                let indexPath = IndexPath(row: (self.messages.count-1), section: 0)
//                self.chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
            
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
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            singleSnap()
//            self.performSegue(withIdentifier: "imgView", sender: self)
//            presentPhotoPicker(source: .camera)
        }
        else
        {
            print("Camera Not Accessable")
        }
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
//            let ImgVC = storyboard?.instantiateViewController(withIdentifier: "ImageVC")
//            self.present(ImgVC!, animated: true) {
//                self.presentPhotoPicker(source: .photoLibrary)
//            }
//
//            presentPhotoPicker(source: .photoLibrary)
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
    
    func singleSnap()
    {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                self.msgImg = photo.image
            }
//            picker.dismiss(animated: true, completion: nil)
            picker.dismiss(animated: true, completion:
                {
                    self.sendImgMsg(conversationID: self.conversationID!)
                    //print(self.msgImgURL!)
                })
        }
        present(picker, animated: true, completion: nil)
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
        getDateTime()
        
        let convo1 = Conversation(conversationID: "\(users[0]!+users[1]!)", dateCreated: "\(dateAndTime!)", users: users as? [String], convoName: "", convoLastMessage: "" , convoLastMessageTime:"", convoImgURL: "")
        
        oneToOneConvoServices.createOneToOneConvo(conversation: convo1) { (convo, success, error) in
            if success == true{
                print("Convo created : \(convo!.conversationID!)")
                self.userService.updateConversationList(convoID: convo?.conversationID, users: users)
                
                completion(true,convo?.conversationID)
            }else{
                print(error!)
                completion(false,error)
            }
        }
    }
    
    
    func checkForExistance(completion:@escaping(Bool)->Void)
    {
        oneToOneConvoServices.checkIfOneToOneConvoExists(users: users as! [String]) { (count) in
            
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
    
    func sendImgMsg(conversationID:String)
    {
        getDateTime()
        getDate()
        getTime()
        
        self.messageService.uploadMsgImg(convoID: "\(self.conversationID!)", image: self.msgImg, completion:
            {
                (url, error) in
                guard let url = url
                    else
                {
                    guard let error = error else { return }
                    print("Error: \(error)")
                    return
                }
                
                self.msgImgURL = url
                
                
                let message1 = Message(msgid: "test", uid: self.delegate.currentUser!.uid!, dateTime: "\(self.dateAndTime!)", date: "\(self.dateOnly!)", time: "\(self.timeOnly!)", conversationID: self.conversationID, incoming: false, message: self.msgImgURL!)
                
                self.messageService.createMessage(message: message1, ConvoID: self.conversationID)
                {
                    (message, success, error) in
                    if success == true
                    {
                        print("Sent Successfully: \(message!)")
                    }
                    else
                    {
                        print(error!)
                    }
                }
                
                self.oneToOneConvoServices.updateConvo(convoID: self.conversationID!, msg: self.msgImgURL!, time: self.dateAndTime!)
            })
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
                print("Sent Successfully: \(message!)")
            }
            else
            {
                print(error!)
            }
        }
        
        oneToOneConvoServices.updateConvo(convoID: self.conversationID!, msg: msgTxt.text, time: dateAndTime!)
    }
    
    func getMsgs()
    {
        messageService.getOneToOneMsgs(convoID: /*"\(users[0]!+users[1]!)"*/self.conversationID!) { (messageArray, error) in
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
    
//    func getConvoUsers2(completion:@escaping([Conversation?]?)->Void)
//    {
//        oneToOneConvoServices.getConvoUsers(convoID: self.conversationID, completion:
//            {
//                (conversation, error) in
//                
//                if error != nil
//                {
//                    print(error)
//                }
//                else
//                {
//                    print(conversation)
//                    completion(conversation!)
//                }
//        })
//    }
    
//    func getConvoUsers(completion:@escaping([String?]?)->Void)
//    {
//
//        oneToOneConvoService.getConvoUsers(convoID: self.conversationID!)
//        {
//            (usersArray, error) in
//            guard let usersArray = usersArray else
//            {
//                print("Error: \(error)")
//                completion(nil)
//                return
//            }
//
//            for i in usersArray
//            {
//                self.users.append(i!.uid)
//                print(i!.uid)
//            }
//            completion(self.users)
//            print(self.users)
//        }
//    }
    
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
    
    func scrollToLastRow()
    {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        self.chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        //self.chat.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .bottom)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
//        DispatchQueue.main.async
//        {
//            self.scrollToLastRow()
//        }
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
        
//        getConvoUsers2
//            {
//                (conversations) in
//                guard let conversations = conversations else
//                {
//                    return
//                }
//
//                self.users = []
//
//                for i in conversations
//                {
//                    self.users = i!.users!
//                }
//            }
        
//        getConvoUsers
//            {
//                (usersArray) in
//                guard let usersArray = usersArray else
//                {
//                    print("Get ready for error Error Time")
//                    return
//                }
//
//                self.users.removeAll()
//                self.users = usersArray
//
//                print(self.users)
//        }
        
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
        
//                    self.getConvoUsers
//                        {
//                            (usersArray) in
//                            guard let usersArray = usersArray else
//                            {
//                                print("Get ready for error Error Time")
//                                return
//                            }
//
//                            self.users.removeAll()
//                            self.users = usersArray
//
//                            print(self.users)
//                    }
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
                                //print("1:\(self.conversationID)")

                                self.getMsgs()
                                
//                                self.getConvoUsers
//                                    {
//                                        (usersArray) in
//                                        guard let usersArray = usersArray else
//                                        {
//                                            print("Get ready for error Error Time")
//                                            return
//                                        }
//
//                                        self.users.removeAll()
//                                        self.users = usersArray
//
//                                        print(self.users)
//                                }
                                
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

        for i in users
        {
            if i != delegate.currentUser!.uid!
            {
                let tmpID = i!
                
                userService.getSpecificUser(userID: tmpID) { (user, error) in
                    guard let user = user else
                    {
                        print("Error : \(error!)")
                        return
                    }
                    
                    self.otherUser = user
                    
                    self.navigationController?.navigationBar.topItem?.title = "\(self.otherUser!.name!)"
                }
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
        let loadingNib = UINib(nibName: "loadingCell", bundle: nil)
        chat.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        
        //Dont need HeightForRowAt when making tableviewcell like this
        //self.chat.rowHeight = UITableView.automaticDimension
    }
}

extension chatVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0
//        {
            let cell = chat.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! chatCell
        
        //This Code Inverts The TableView Completely, not what i need atm
//        chat.transform = CGAffineTransform(scaleX: 1, y: -1)
//        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//        cell.accessoryView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        
            if messages.count == 0
            {
                noMsgTxt.isHidden = false
                chat.isHidden = true
            }
            else
            {
                noMsgTxt.isHidden = true
                chat.isHidden = false
            
                if (messages[indexPath.row]!.message?.contains("https://firebasestorage"))!
                {
                    cell.bubbleView.chatLbl.isHidden = true
                    cell.setData1(messages[indexPath.row]!)
                }
                else
                {
//                DispatchQueue.main.async {
//                    cell.setData(self.messages[indexPath.row]!)
//                    self.scrollToLastRow()
//                }
                    cell.bubbleView.chatLbl.isHidden = false
                    cell.setData(messages[indexPath.row]!)
                }
//            chat.scrollToRow(at: indexPath, at: .bottom, animated: true)          
            }
        cell.contentView.backgroundColor = UIColor.clear
        chat.backgroundColor = UIColor.clear
        cell.bubbleView.backgroundColor = UIColor.clear

//        DispatchQueue.main.async {
//            self.scrollToLastRow()
//        }
        
        return cell
//        }
//        else
//        {
//            let cell = chat.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! loadingCell
//
//            cell.spinner.startAnimating()
//
//            self.chat.rowHeight = 50
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if section == 0
//        {
            return messages.count
//        }
//        else if section == 1 && getMoreData
//        {
//            return 1
//        }
//        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let cell = chat.cellForRow(at: indexPath) as! chatCell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        //let cell = chat.cellForRow(at: indexPath) as! chatCell
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height * 2
//        {
//            if !getMoreData {
//                fetchBatch()
//            }
//        }
//    }
    
//    func fetchBatch()
//    {
//        getMoreData = true
//        print("beginFetchingData")
//        chat.reloadSections(IndexSet(integer: 1), with: .none)
//        DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
//        {
//            self.getMoreData = false
//            self.chat.reloadData()
//        }
//    }
}

extension chatVC: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        handleButton()
    }
}


//extension chatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
//{
//    func presentPhotoPicker(source: UIImagePickerController.SourceType)
//    {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = source
//        present(picker , animated: true , completion: nil)
//    }
//
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true) {
//            self.performSegue(withIdentifier: "imgView", sender: self)
//        }
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            print("got image")
//            selectedImage = image
//            //profileImgOut.setImage(image, for: .normal)
//        }else {
//            print("no image")
//            let image = UIImage(named: "profilePic")
//            //profileImgOut.setImage(image, for: .normal)
//        }
//    }
//}

//extension chatVC
//{
//    //MARK: -Prepare for Segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.identifier == "imgView"
//        {
//            let imgData = segue.destination as! ImageVC
//
//            imgData.img = selectedImage
//        }
//    }
//}
