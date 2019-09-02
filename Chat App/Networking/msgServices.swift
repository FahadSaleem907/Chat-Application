//
//  msgFunctions.swift
//  Chat App
//
//  Created by Fahad Saleem on 8/31/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

public class messageFunctions
{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var db = Firestore.firestore()
    
    func createMessage(message:Message?,completion:@escaping(Message?,Bool?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        let message1 = Message(msgid: message!.msgid!, uid: message!.uid, dateTime: message!.dateTime!, date: message!.date!, time: message!.time!, conversationID: message!.conversationID!, incoming: false, message: message!.message!)
        
        let dataDic : [String:Any] = [
                                        "msgid":"\(message1.msgid)",
                                        "uid":"\(message1.uid)",
                                        "dateTime":"\(message1.dateTime)",
                                        "date":"\(message1.date)",
                                        "time":"\(message1.time)",
                                        "conversationID":"\(message1.conversationID)",
                                        "incoming":false,
                                        "message":"\(message1.message)"
                        ]
        
        
        //ref = self.db.collection("Messages").document("\()")
        
    }
    
    func deleteMessage()
    {
        
    }
    
    func getMessages()
    {
        
    }
}
