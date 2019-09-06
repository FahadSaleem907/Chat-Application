import UIKit

class chatListVC: UIViewController
{

    // MARK: - Constants
    let conversationServices = conversationFunctions()
    
    // MARK: - Variables
    fileprivate var filtered = [Conversation?]()
    fileprivate var filterring = false
    var userList = [String?]()
    var convoList = [Conversation?]()
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        getConvoList
            {
                (convo) in
                guard let convo = convo else { return }
                
                self.convoList.removeAll()
                self.convoList = convo
                print(self.convoList)
            }
        
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
                
                return (i!.conversationID?.lowercased().contains(text.lowercased()))!
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [Conversation?]()
        }
        self.chatList.reloadData()
    }
}

extension chatListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = chatList.dequeueReusableCell(withIdentifier: "cell") as! chatListCell
        
        cell.chatName.text = convoList[indexPath.row]?.conversationID
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
            userList = convoList[chatList.indexPathForSelectedRow!.row]!.users!
            chatVCData.users = userList
            chatVCData.conversationID = convoList[chatList.indexPathForSelectedRow!.row]!.conversationID
        }
    }
}
