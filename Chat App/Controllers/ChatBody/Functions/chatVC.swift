import UIKit

class chatVC: UIViewController
{
    
    fileprivate var filtered = [String]()
    fileprivate var filterring = false
    
    //MARK: - Constants
    //let lbl = customChatTVCell()
    
    let tmpArray = ["A short message.",
                    "A medium length message, longer than short.",
                    "A long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content.",
                    "Another short message.",
                    "Another medium length message, longer than short.",
                    "Another long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content."
    ]
    
    let theData: [Message] = [
        
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: false, message: "A short message."),
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: true, message: "A medium length message, longer than short."),
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: false, message: "A long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content."),
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: true, message: "Another short message."),
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: false, message: "Another medium length message, longer than short."),
        Message(userID: nil, date: nil, time: nil, conversationID: nil, incoming: true, message: "Another long message. This one should be long enough to wrap onto multiple lines, showing that this message bubble cell will auto-size itself to the message content.")
    ]
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var chat: UITableView!
    
    
    //MARK: - Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        chat.delegate   = self
        chat.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.sizeToFit()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 30) ?? UIFont.systemFont(ofSize: 30)]
        //checkTextView()
        // Do any additional setup after loading the view.
        
        chat.register(chatCell.self, forCellReuseIdentifier: "cell")
    }
}

extension chatVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chat.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! chatCell
        cell.setData(theData[indexPath.row])
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
        
//        cell.contentView.topAnchor.constraint(equalTo: cell.bubbleView.topAnchor, constant: 30)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = chat.cellForRow(at: indexPath) as! chatCell
        
//        cell.contentView.topAnchor.constraint(equalTo: cell.bubbleView.topAnchor, constant: 12)
    }
}

extension chatVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController)
    {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.tmpArray.filter({ (i) -> Bool in
                //return tmpArray.lowercased().contains(text.lowercased())
                
                return i.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [String]()
        }
        self.chat.reloadData()
    }
}
