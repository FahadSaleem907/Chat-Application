import Foundation
import UIKit


class loginVC: UIViewController
{

    // MARK: - Constants
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let userServiecs = userFunctions()
//    let router = RouteManager.shared
    
    // MARK: - Variables
    
    // MARK: - Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: UIButton)
    {
        if userName.text?.isEmpty == true
        {
            print("Enter User Name")
        }
        else if password.text?.isEmpty == true
        {
            print("Enter Password")
        }
        else
        {
            login()
        }
    }
    
    
    
    // MARK: - Functions
    func login()
    {
        userServiecs.login(email: userName.text!, password: password.text!)
        {
            (user, error, success) in
            if error != nil
            {
                print(error!)
            }
            else
            {
//                self.userName.text = ""
//                self.password.text = ""
                guard let success = success else { return }
                
                if success == true
                {
                    self.performSegue(withIdentifier: "login", sender: self)
                    //self.router.showHome()
                }
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

