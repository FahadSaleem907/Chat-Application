import UIKit
import SDWebImage

class chatListVC: UIViewController
{

    // MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let userServices = userFunctions()
    let conversationServices = conversationFunctions()
    let oneToOneConvoServices = oneToOneConvoFunctions()
    
    // MARK: - Variables
    fileprivate var filtered = [String?]()
    fileprivate var filterring = false
    var otherUser:User?
    var lastDate:String?
    var days:Int?
    var dateDifference:Int?
    var convoID:String?
    var userList = [String?]()
    var convos = [Conversation?]()
    {
        didSet
        {
            chatList.reloadData()
        }
    }
    var convoList = [String?]()
    {
        didSet
        {
            chatList.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var chatList: UITableView!
    @IBOutlet weak var noChatsLbl: UILabel!
    
    // MARK: - Actions
    
    // MARK: - Functions
    
    func getConvoList(completion:@escaping([Conversation?]?)->Void)
    {
        conversationServices.getConversations { (conversation, error) in

            if error != nil
            {
                print(error!)
            }
            else
            {
                print(conversation!)
                completion(conversation!)
            }
        }
    }
    
    func getOneToOneConvoList(completion:@escaping([String?]?)->Void)
    {
        oneToOneConvoServices.getConversations { (convoArr, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                print("Got Conversation List")
                completion(convoArr)
            }
        }
    }
    
    func handleChatList()
    {
        if convoList.count == 0
        {
            noChatsLbl.isHidden = false
            chatList.isHidden   = true
        }
        else
        {
            chatList.isHidden   = false
            noChatsLbl.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getConvoList
            {
                (convo) in
                guard let convo = convo else { return }

                self.convos.removeAll()
                self.convos = convo
                print(self.convos)
            }

        getOneToOneConvoList
            {
                (array) in
                guard let array = array else
                {
                    print("No Convo Found")
                    return
                }
                self.convoList.removeAll()
                self.convoList = array
                print(array)
                self.handleChatList()
                print(self.convoList.count)
        }
        print(convoList.count)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func sendMessage()
    {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.isHidden = false
       
        navigationController?.navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 30) ?? UIFont.systemFont(ofSize: 30)]
        navigationController?.navigationBar.sizeToFit()
        
//       navigationController?.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        chatList.delegate   = self
        chatList.dataSource = self
    
    }
}

extension chatListVC:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.convoList.filter({ (i) -> Bool in
                //return tmpArray.lowercased().contains(text.lowercased())
                
                //return i.lowercased().contains(text.lowercased())
                
                return (i!.lowercased().contains(text.lowercased()))
                //return (i!.conversationID?.lowercased().contains(text.lowercased()))!
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [String?]()
        }
        self.chatList.reloadData()
    }
}

extension chatListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = chatList.dequeueReusableCell(withIdentifier: "cell") as! chatListCell
        
        cell.mainView.backgroundColor = .init(red: 140/255, green: 200/255, blue: 62/255, alpha: 0.5)
        cell.layer.cornerRadius = 25
        cell.backgroundColor = .clear
        
        let tmpID = convoList[indexPath.row]!.replacingOccurrences(of: "\(delegate.currentUser!.uid!)", with: "")
        userServices.getSpecificUser(userID: tmpID) { (user, error) in
            guard let user = user else
            {
                print("Error : \(error!)")
                return
            }
            
            self.otherUser = user
            cell.chatName.text = self.otherUser!.name!
            let imgURLString = "\(self.otherUser!.downloadURL!)"
            let imgURL = URL(string: imgURLString)
            cell.img!.sd_setImage(with: imgURL!, completed: nil)
        }
        
        oneToOneConvoServices.getSpecificConvoData(convoID: convoList[indexPath.row]!) { (conversation, error) in
            guard let conversation = conversation else
            {
                print("Error: \(error!)")
                return
            }
            
            let timeSinceLastMessage = conversation.convoLastMessageTime
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            let dateA = dateFormatter.date(from: timeSinceLastMessage!)
            if conversation.convoLastMessageTime != ""
            {
                let time = self.getDateDifference(sinceDate: dateA!)
                cell.date.text = time
            }
            else
            {
                cell.date.text = ""
            }
            cell.lastMessage.text = conversation.convoLastMessage
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return convoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "chatVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "chatVC"
        {
            let chatVCData = segue.destination as! chatVC
        
            userList = []
            self.userList = convos[chatList.indexPathForSelectedRow!.row]!.users!
            convoID = convoList[chatList.indexPathForSelectedRow!.row]//!.users!

            print(convos[chatList.indexPathForSelectedRow!.row]?.users!)
            print(userList)
            print(convoID)
            
            chatVCData.users = userList
            chatVCData.conversationID = convoID! //convoList[chatList.indexPathForSelectedRow!.row]//!.conversationID
        }
    }
}

extension chatListVC
{
    func getDateDifference(sinceDate: Date) -> String?
    {
        let date = Date()
        dateDifference = date.seconds(sinceDate: sinceDate)
        print(dateDifference!)
        if dateDifference! > 60
        {
            dateDifference = date.minutes(sinceDate: sinceDate)
            if dateDifference! > 60
            {
                dateDifference = date.hours(sinceDate: sinceDate)
                if dateDifference! > 24
                {
                    dateDifference = date.days(sinceDate: sinceDate)
                    
                    if dateDifference! == 1
                    {
                        lastDate = "Yesterday"
                    }
                    else
                    {
                        let now = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "LLLL"
                        let nameOfMonth = dateFormatter.string(from: now)
                        
                        if nameOfMonth == "January"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!) Days"
                            }
                        }
                        else if nameOfMonth == "February"
                        {
                            let now = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy"
                            let year = dateFormatter.string(from: now)
                            let currentYear = Int(year)
                            
                            if currentYear! % 4 == 0
                            {
                                if dateDifference! > 29
                                {
                                    dateDifference = date.months(sinceDate: sinceDate)
                                    if dateDifference! > 12
                                    {
                                        dateDifference = date.years(sinceDate: sinceDate)
                                        
                                        lastDate = "\(dateDifference!) Years"
                                    }
                                    else
                                    {
                                        lastDate = "2 Months"
                                    }
                                }
                                else
                                {
                                    lastDate = "\(dateDifference!)  Days"
                                }
                            }
                            else
                            {
                                if dateDifference! > 28
                                {
                                    dateDifference = date.months(sinceDate: sinceDate)
                                    if dateDifference! > 12
                                    {
                                        dateDifference = date.years(sinceDate: sinceDate)
                                        
                                        lastDate = "\(dateDifference!) Years"
                                    }
                                    else
                                    {
                                        lastDate = "2 Months"
                                    }
                                }
                                else
                                {
                                    lastDate = "\(dateDifference!) Days"
                                }
                            }
                        }
                        else if nameOfMonth == "March"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "3 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "April"
                        {
                            if dateDifference! > 30
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "4 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "May"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "5 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "June"
                        {
                            if dateDifference! > 30
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "6 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "July"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "7 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "August"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "8 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "September"
                        {
                            if dateDifference! > 30
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "9 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "October"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "10 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "November"
                        {
                            if dateDifference! > 30
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                                else
                                {
                                    lastDate = "11 Months"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                        else if nameOfMonth == "December"
                        {
                            if dateDifference! > 31
                            {
                                dateDifference = date.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = date.years(sinceDate: sinceDate)
                                    
                                    lastDate = "\(dateDifference!) Years"
                                }
                            }
                            else
                            {
                                lastDate = "\(dateDifference!)  Days"
                            }
                        }
                    }
                }
                else
                {
                    lastDate = "\(dateDifference!) Hours"
                }
            }
            else
            {
                lastDate = "\(dateDifference!) Minutes"
            }
        }
        else
        {
            lastDate = "\(dateDifference!) Seconds"
        }
        return lastDate
    }
}

