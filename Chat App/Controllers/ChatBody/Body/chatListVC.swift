import UIKit

class chatListVC: UIViewController
{

    // MARK: - Constants
    let conversationServices = conversationFunctions()
    let oneToOneConvoServices = oneToOneConvoFunctions()
    
    // MARK: - Variables
    fileprivate var filtered = [String?]()
    fileprivate var filterring = false
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
    
//    func getConvoUsers1(completion:@escaping([Conversation?]?)->Void)
//    {
//        oneToOneConvoServices.getConvoUsers(convoID: convoList[chatList.indexPathForSelectedRow!.row], completion:
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
//            })
//    }
    
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
        
        
//        getConvoUsers { (conversations) in
//            guard let conversations = conversations else
//            {
//                return
//            }
//
//            self.userList = []
//
//            for i in conversations
//            {
//                self.userList = i!.users!
//            }
//        }
        
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
        cell.chatName.text = convoList[indexPath.row]//.conversationID
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
        
//        getConvoUsers1 { (conversations) in
//            guard let conversations = conversations else
//            {
//                return
//            }
//
//            self.userList = []
//
//            for i in conversations
//            {
//                self.userList = i!.users!
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "chatVC"
        {
            let chatVCData = segue.destination as! chatVC
        
            userList = []
            self.userList = convos[chatList.indexPathForSelectedRow!.row]!.users!
            convoID = convoList[chatList.indexPathForSelectedRow!.row]//!.users!
//            oneToOneConvoServices.getConvoUsers(convoID: convoID!)
//            {
//                (usersArray, error) in
//                guard let usersArray = usersArray else
//                {
//                    print("Error: \(error)")
//                    return
//                }
//
//                for i in usersArray
//                {
//                    self.userList.append(i!.uid)
//                    print(i?.uid)
//                }
//                chatVCData.users = self.userList
//            }
            
//            getConvoUsers1 { (conversations) in
//                guard let conversations = conversations else
//                {
//                    return
//                }
//
//                self.userList = []
//
//                for i in conversations
//                {
//                    self.userList = i!.users!
//                }
//            }
            print(userList)
            
            chatVCData.users = userList
            chatVCData.conversationID = convoID! //convoList[chatList.indexPathForSelectedRow!.row]//!.conversationID
        }
    }
}



extension chatListVC
{
    func getDateDifference(sinceDate: Date) -> String?
    {
        dateDifference = sinceDate.seconds(sinceDate: sinceDate)
        
        if dateDifference! > 60
        {
            dateDifference = sinceDate.minutes(sinceDate: sinceDate)
            if dateDifference! > 60
            {
                dateDifference = sinceDate.hours(sinceDate: sinceDate)
                if dateDifference! > 24
                {
                    dateDifference = sinceDate.days(sinceDate: sinceDate)
                    
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                    
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
                                    dateDifference = sinceDate.months(sinceDate: sinceDate)
                                    if dateDifference! > 12
                                    {
                                        dateDifference = sinceDate.years(sinceDate: sinceDate)
                                        
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
                                    dateDifference = sinceDate.months(sinceDate: sinceDate)
                                    if dateDifference! > 12
                                    {
                                        dateDifference = sinceDate.years(sinceDate: sinceDate)
                                        
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                    
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                    
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
                                dateDifference = sinceDate.months(sinceDate: sinceDate)
                                if dateDifference! > 12
                                {
                                    dateDifference = sinceDate.years(sinceDate: sinceDate)
                                    
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
