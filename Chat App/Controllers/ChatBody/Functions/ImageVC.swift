import Foundation
import UIKit

class ImageVC: UIViewController
{
    //MARK: -Constants

    
    //MARK: -Variables
    var img:UIImage?
    
    //MARK: -Outlets
    @IBOutlet weak var userPic: UIImageView!
    
    @IBOutlet weak var capturedPic: UIImageView!
    
    //MARK: -Actions
    
    @IBAction func backBtn(_ sender: UIButton)
    {
        print("Back button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: UIButton)
    {
        print("send button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        capturedPic.image = img
        // Do any additional setup after loading the view.
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
