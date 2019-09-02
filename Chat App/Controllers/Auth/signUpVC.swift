import UIKit

class signUpVC: UIViewController
{

    // MARK: - Constants
    let userServices    = userFunctions()
    var downloadURL     = ""
    
    // MARK: - Variables
    // MARK: - Outlets
    @IBOutlet weak var profileImgOut: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    
    // MARK: - Actions
    @IBAction func profileImgAct(_ sender: UIButton)
    {
        imageAlert()
    }
    
    @IBAction func createUser(_ sender: UIButton)
    {
        createUser()
    }
    
    
    // MARK: - Functions
    
    func createUser()
    {
        let user1 = User(name: name.text, email: email.text, password: password.text,dateOfBirth: dateOfBirth.text, gender: gender.text, downloadURL: "\(self.downloadURL)", isOnline: false, uid: nil)

        userServices.createUser(user: user1)
        {
            (user, success, error) in
            if let err = error
            {
                print("\(err)")
            }
            else
            {
                let newUser = user

                self.userServices.uploadImg(uid: "\(newUser!.uid!)", image: self.profileImgOut.currentImage!, completion:
                    {
                        (url, error) in
                        guard let url = url
                        else
                        {
                            guard let error = error else { return }
                            print("Error: \(error)")
                            return
                        }

                        self.downloadURL = url
                        self.userServices.updateIMGUrl(users: newUser, url: self.downloadURL)
                    })
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        let height = profileImgOut.frame.height
        profileImgOut.layer.cornerRadius = height / 2
        profileImgOut.layer.masksToBounds = true
        profileImgOut.contentMode = .scaleToFill
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

extension signUpVC
{
    func alert(msg:String , controller:UIViewController, textField:UITextField)
    {
        let alertValidation = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "Okay", style: .default)
        {
            (_) in textField.becomeFirstResponder()
        }
        alertValidation.addAction(buttonOK)
        present(alertValidation, animated: true, completion: nil)
    }
    
    
    func statusAlert(title:String, msg:String, controller:UIViewController)
    {
        let alertValidation = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "Okay", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true) })
        alertValidation.addAction(buttonOK)
        present(alertValidation, animated: true, completion: nil)
    }
    
    
    func imageAlert()
    {
        let imgAlert = UIAlertController(title: "", message: "Selection Type", preferredStyle: .actionSheet)
        
        let takePicBtn = UIAlertAction(title: "Camera", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.presentPhotoPicker(source: .camera)
            }
            else
            {
                print("Camera Not Available or Accessable")
            }
        }
        
        let choosePicBtn = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            self.presentPhotoPicker(source: .photoLibrary)
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        imgAlert.addAction(takePicBtn)
        imgAlert.addAction(choosePicBtn)
        imgAlert.addAction(cancelBtn)
        
        present(imgAlert, animated: true, completion: nil)
    }
}

extension signUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func presentPhotoPicker(source: UIImagePickerController.SourceType)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        present(picker , animated: true , completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("got image")
            profileImgOut.setImage(image, for: .normal)
        }else {
            print("no image")
            let image = UIImage(named: "profilePic")
            profileImgOut.setImage(image, for: .normal)
        }
    }
}
