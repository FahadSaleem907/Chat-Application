import Foundation
import UIKit

struct User
{
    var name:String? = ""
    var email:String? = ""
    var password:String? = ""
    var dateOfBirth:String? = ""
    var gender:String? = ""
    var downloadURL:String? = ""
    var isOnline:Bool? = false
    var uid:String? = ""
    var conversations:[String]? = []
    
//    init(name:String?, email:String?, dateOfBirth:String?, gender:String?, downloadURL:String?, isOnline:Bool?, uid:String?)
//    {
//        self.name           = name
//        self.email          = email
//        self.dateOfBirth    = dateOfBirth
//        self.gender         = gender
//        self.downloadURL    = downloadURL
//        self.isOnline       = isOnline
//        self.uid            = uid
//    }
    
    init(name:String?, email:String?, password:String?, dateOfBirth:String?, gender:String?, downloadURL:String?, isOnline:Bool?, uid:String?)
    {
        self.name           = name
        self.email          = email
        self.password       = password
        self.dateOfBirth    = dateOfBirth
        self.gender         = gender
        self.downloadURL    = downloadURL
        self.isOnline       = isOnline
        self.uid            = uid
    }
}
