import UIKit

class chatListVC: UIViewController
{

    // MARK: - Constants
    var testArray = ["A","B","c","d","F","g"]
    
    // MARK: - Variables
    fileprivate var filtered = [String]()
    fileprivate var filterring = false
    
    // MARK: - Outlets
    @IBOutlet weak var chatList: UITableView!
    
    // MARK: - Actions
    // MARK: - Functions
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        tabBarController?.tabBar.isHidden = false
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
    }
}

extension chatListVC:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.testArray.filter({ (i) -> Bool in
                //return tmpArray.lowercased().contains(text.lowercased())
                
                return i.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [String]()
        }
        self.chatList.reloadData()
    }
}

extension chatListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = chatList.dequeueReusableCell(withIdentifier: "cell") as! chatListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
