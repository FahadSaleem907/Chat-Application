import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

public class userFunctions
{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var db = Firestore.firestore()
    var userList = [User?]()
    
//    func login(email:String,password:String,completion:@escaping(User?,String)->Void)
//    {
//        Auth.auth().signIn(withEmail: email, password: password)
//        {
//            (result, error) in
//
//            if error != nil
//            {
//                let error = error!.localizedDescription
//                completion(nil,error)
//            }
//            else
//            {
//
//            }
//        }
//    }
    
    func createUser(user:User?,completion:@escaping(User?,Bool,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        Auth.auth().createUser(withEmail: user!.email!, password: user!.password!)
        {
            (result, error) in
            if error != nil
            {
                let error = error!.localizedDescription
                completion(nil,false,error)
            }
            else
            {
                var users = User(name: user?.name, email: user?.email, password: user?.password, dateOfBirth: user?.dateOfBirth, gender: user?.gender, downloadURL: user?.downloadURL, isOnline: user?.isOnline, uid: user?.uid)
                
                users.uid           = result?.user.uid
                users.name          = user?.name
                users.email         = user?.email
                users.password      = user?.password
                users.dateOfBirth   = user?.dateOfBirth
                users.gender        = user?.gender
                users.downloadURL   = user?.downloadURL
                users.isOnline      = user?.isOnline
                
                print("User Created: \(users.uid! + users.name!)")
                
                let dataDic : [String:Any]  =   [
                                                "name":"\(users.name!)",
                                                "email":"\(users.email!)",
                                                "dateOfBirth":"\(users.dateOfBirth!)",
                                                "gender":"\(users.gender!)",
                                                "downloadURL":"\(users.downloadURL!)",
                                                "isOnline":users.isOnline!,
                                                "uid":"\(users.uid!)",
                                                "conversations":[]
                                                ]
                
                ref = self.db.collection("Users").document("\(users.uid!)")
                ref?.setData(dataDic, completion:
                    {
                        (err) in
                        if let err = err
                        {
                            print(err.localizedDescription)
                            completion(nil,false,err.localizedDescription)
                        }
                        else
                        {
                            print("Account Created")
                            completion(users,true,nil)
                        }
                    })
            }
        }
    }
    
    
    func updateUser()
    {
        
    }
    
    func deleteUser()
    {
        
    }
    
    func getUser()
    {
        let fetchUsers = self.db.collection("Users")
        
        fetchUsers.addSnapshotListener
            {
                (snapshot, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    for i in snapshot!.documents
                    {
                        self.userList = []
                        
                        let tmpUser = User(name: i.data()["name"] as! String, email: i.data()["email"] as! String, password: nil, dateOfBirth: i.data()["dateOfBirth"] as! String, gender: i.data()["gender"] as! String, downloadURL: i.data()["downloadURL"] as! String, isOnline: false, uid: i.data()["uid"] as! String)
                    }
                }
            }
    }
    
    func uploadImg(uid:String?,image:UIImage?,completion:@escaping(_ url:String?,_ error:String?)->Void)
    {
        let storageRef:StorageReference!
        storageRef = Storage.storage().reference()
        
        let storageFile = storageRef.child("ProfileImage").child("\(uid!)")
        var imageData:Data? = nil
        
        imageData = image?.jpegData(compressionQuality: 0.2)
        print(imageData!)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageFile.putData(imageData!, metadata: metaData)
        {
            (metaData, error) in
            if error != nil
            {
                print("ERROR : \(error?.localizedDescription)")
                return
            }
            else
            {
                let metaData = metaData
                
                storageFile.downloadURL(completion:
                    {
                        (url, error) in
                        if let error = error
                        {
                            print("Error In Image: \(error.localizedDescription)")
                            completion(nil,error.localizedDescription)
                        }
                        else
                        {
                            let downloadURL = url!.absoluteString
                            print("Image uploaded successfully: \(downloadURL)")
                            completion(downloadURL,nil)
                        }
                })
            }
        }
    }
    
    func updateIMGUrl(users:User?,url:String?)
    {
        let ref = self.db.collection("Users").document("\(users!.uid!)")
        
        ref.setData(["downloadURL" : "\(url!)"], merge: true)
    }
    
}
