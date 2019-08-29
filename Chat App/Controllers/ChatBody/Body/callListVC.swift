import UIKit

class callListVC: UIViewController
{

    // MARK: - Constants
    var testArray = ["A","B","c","d","F","g"]
    
    
    // MARK: - Variables
    fileprivate var filtered = [String]()
    fileprivate var filterring = false
    
    // MARK: - Outlets
    @IBOutlet weak var callList: UITableView!
    
    
    // MARK: - Actions
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        callList.delegate   = self
        callList.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 30) ?? UIFont.systemFont(ofSize: 30)]
        navigationController?.navigationBar.sizeToFit()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
}

extension callListVC:UISearchResultsUpdating
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
        self.callList.reloadData()
    }
}

extension callListVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = callList.dequeueReusableCell(withIdentifier: "cell") as! callListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
