import UIKit
import FirebaseAuth

class moreVC: UIViewController
{

    // MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let userServices = userFunctions()
    
    // MARK: - Variables
    // MARK: - Outlets
    @IBOutlet weak var profileImgOut: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusOut: UIButton!
    
    // MARK: - Actions
    @IBAction func logout(_ sender: UIButton)
    {
        handleLogout()
    }
    
    
    // MARK: - Functions
    
    @objc func handleLogout()
    {
        do
        {
            try Auth.auth().signOut()
           self.userServices.updateUserOfflineStatus(uid: delegate.currentUser!.uid!)
            print(Auth.auth().currentUser?.uid)
            
            
        }
        catch let logoutError
        {
            print(logoutError)
        }
    }
    
    func getData()
    {
        let imgURLString = "\(delegate.currentUser!.downloadURL!)"
        let imgURL = URL(string: imgURLString)
        profileImgOut.sd_setImage(with: imgURL!, for: .normal, completed: nil)
        
        name.text = delegate.currentUser!.name
        
        if delegate.currentUser!.isOnline == true
        {
            statusOut.setTitle("Online", for: .normal)
        }
        else
        {
            statusOut.setTitle("Offline", for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        let height = profileImgOut.frame.height
        profileImgOut.layer.cornerRadius = height/2
        profileImgOut.layer.masksToBounds = true
        profileImgOut.contentMode = .scaleToFill
    }
    
    override func viewWillAppear(_ animated: Bool)
    {    
        getData()
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
