import UIKit

class loginVC: UIViewController
{

    // MARK: - Constants
    let userServiecs = userFunctions()
    
    // MARK: - Variables
    // MARK: - Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: UIButton)
    {
        login()
    }
    
    
    
    // MARK: - Functions
    func login()
    {
        userServiecs.login(email: userName.text!, password: password.text!)
        {
            (user, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews()
    {
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad()
    {
        userName.text = "test@test.com"
        password.text = "123123"
        super.viewDidLoad()
    }
}

