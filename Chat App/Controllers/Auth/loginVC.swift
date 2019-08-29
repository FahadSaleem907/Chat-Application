import UIKit

class loginVC: UIViewController
{

    // MARK: - Constants
    
    
    // MARK: - Variables
    // MARK: - Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: UIButton)
    {
        
    }
    
    
    
    // MARK: - Functions

    override func viewDidLayoutSubviews()
    {
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

