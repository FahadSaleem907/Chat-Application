import UIKit

class chatListVC: UIViewController
{

    // MARK: - Constants
    let conversationServices = conversationFunctions()
    let oneToOneConvoServices = oneToOneConvoFunctions()
    
    // MARK: - Variables
    fileprivate var filtered = [String?]()
    fileprivate var filterring = false
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
    
    // MARK: - Actions
    // MARK: - Functions
    
    func getConvoList(completion:@escaping([Conversation?]?)->Void)
    {
        conversationServices.getConversations { (conversation, error) in

            if error != nil
            {
                print(error)
            }
            else
            {
                print(conversation)
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
                print(error)
            }
            else
            {
                print("Got Conversation List")
                completion(convoArr)
            }
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
        }
        
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
