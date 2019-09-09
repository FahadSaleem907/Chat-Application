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
    
    func createMessage(message:Message?,ConvoID:String?,completion:@escaping(Message?,Bool?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        let message1 = Message(msgid: message!.msgid!, uid: message!.uid, dateTime: message!.dateTime!, date: message!.date!, time: message!.time!, conversationID: message!.conversationID!, incoming: true, message: message!.message!)
        
        let dataDic : [String:Any] = [
                                        "msgid":"\(message1.msgid!)",
                                        "uid":"\(message1.uid!)",
                                        "dateTime":"\(message1.dateTime!)",
                                        "date":"\(message1.date!)",
                                        "time":"\(message1.time!)",
                                        "conversationID":"\(message1.conversationID!)",
                                        "incoming":true,
                                        "message":"\(message1.message!)"
                        ]
        
        
        ref = self.db.collection("Messages").document()/*("\(ConvoID!)").collection("\(delegate.currentUser!.uid!)").document()*/
        ref?.setData(dataDic, completion:
            {
                (error) in
                if error != nil
                {
                    print("\(error!.localizedDescription)")
                }
                else
                {
                    print("message sent")
                }
        })
        
    }
    
    func getMsgs(convoID:String?,users:[String?],completion:@escaping([Message?]?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        ref = self.db.collection("Messages").document("\(convoID!)")
        
        var tmpArray = [Message]()
        for i in users
        {
            let query = ref?.collection("\(i!)").whereField("conversationID", isEqualTo: "\(convoID!)")
         
            //var tmpArray = [Message]()
            
            query?.addSnapshotListener(
                {
                    (snapshot, error) in
                    guard let snapshot = snapshot else
                    {
                        print("Error : \(error!.localizedDescription)")
                        completion(nil,error!.localizedDescription)
                        return
                    }
                    
//                    self.tmpArray = []
                    for j in snapshot.documents
                    {
                        let tmpMessage = Message(msgid: j.data()["msgid"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                        
                        print(tmpMessage)
                        tmpArray.append(tmpMessage)
                        print(tmpArray.count)
                        //completion(self.tmpArray,nil)
                    }
                    completion(tmpArray,nil)
                })
        }
    }
    
//    func updateIncomingStatus(users:[String?],convoID:String?,message:[Message?])
//    {
//        var ref:DocumentReference? = nil
//        ref = self.db.collection("Messages").document("\(convoID!)")
//        
//        for i in users
//        {
//            let query = ref?.collection("\(i!)").whereField("conversationID", isEqualTo: "\(convoID!)")
//            
//            for j in message
//            {
//                if delegate.currentUser?.uid == j?.uid
//                {
//                    ref!.setData(["incoming" : false], merge: true)
//                }
//                else
//                {
//                    ref!.setData(["incoming" : true], merge: true)
//                }
//            }
//        }
//    }
    
    func getOneToOneMsgs(convoID:String?,completion:@escaping([Message?]?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        var tmpArray = [Message]()
        let query = self.db.collection("Messages").whereField("conversationID", isEqualTo: convoID!)
        
        query.addSnapshotListener(
            {
                (snapshot, error) in
                guard let snapshot = snapshot else
                {
                    print("Error : \(error!.localizedDescription)")
                    completion(nil,error!.localizedDescription)
                    return
                }
                
                tmpArray = []
                for j in snapshot.documents
                {
                    let tmpMessage = Message(msgid: j.data()["msgid"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                    
                    tmpArray.append(tmpMessage)
                }
                completion(tmpArray,nil)
        })
    }
    
    
    func deleteMessage()
    {
        
    }
}
