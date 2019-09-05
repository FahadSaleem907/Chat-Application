import UIKit
import SDWebImage

class newMessageVC: UIViewController
{
    //MARK: -Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -Variables
    var receiverID:String?
    var users = [String?]()
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
    var userList = [User?]()
    {
        didSet
        {

            self.userList.sort
                {
                    (a, b) -> Bool in
                return a!.name! < b!.name!
            }
            userListTable.reloadData()
        }
        
    }
    //MARK: -Outlets
    @IBOutlet weak var userListTable: UITableView!
    
    //MARK: -Actions
    //MARK: -Functions
    
    
    func getUsers(completion:@escaping(_ users:[User?])->Void)
    {
        let userServices = userFunctions()
        userServices.getUser
            {
                (users) in
                self.userList.removeAll()
                self.userList = users!
                completion(self.userList)
            }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getUsers
            {
                (users) in
                self.userList.removeAll()
                self.userList = users
                print(self.userList.count)
        }
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = "Contacts"
        self.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
        userListTable.delegate      = self
        userListTable.dataSource    = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension newMessageVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = userListTable.dequeueReusableCell(withIdentifier: "cell") as! newMessageCell
        
//        cell.img.sd_setImage (with: imgURL! as URL, placeholderImage: UIImage(named: "profilePic"))

        
        let imgURLString = "\(userList[indexPath.row]!.downloadURL!)"
        let imgURL = URL(string: imgURLString)
        cell.img.sd_setImage(with: imgURL!, completed: nil)
        
        cell.userName.text = userList[indexPath.row]?.name
        
        if userList[indexPath.row]?.isOnline == true
        {
            cell.status.image = UIImage(named: "online")
        }
        else
        {
            cell.status.image = UIImage(named: "offline")
        }
        
//        cell.mainView.backgroundColor = .init(red: 148/255, green: 21/255, blue: 81/255, alpha: 0.2)

        cell.mainView.backgroundColor = .init(red: 140/255, green: 200/255, blue: 62/255, alpha: 0.5)
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "chatVC", sender: self)
        
        //let cell = userListTable.cellForRow(at: indexPath) as! newMessageCell
        
        //self.receiverID = userList[indexPath.row]?.uid
        
        print("-------------------")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let data = segue.destination as! chatVC
        users = []
        users = [userList[userListTable.indexPathForSelectedRow!.row]?.uid!]
        data.users = users
        
        receiverID = ""
        receiverID = userList[userListTable.indexPathForSelectedRow!.row]?.uid
        data.receiverID = receiverID
    }
}
