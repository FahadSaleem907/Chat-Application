//
//  oneToOneConvoServices.swift
//  Chat App
//
//  Created by Fahad Saleem on 9/5/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class oneToOneConvoFunctions
{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var db = Firestore.firestore()
    var convoList = [String?]()
    var conversations = [Conversation?]()
    
    func checkIfOneToOneConvoExists(users:[String?],completion:@escaping(Int?)->Void)
    {
        let checkIfExists = self.db.collection("conversation")
        print(users)
        let query = checkIfExists.whereField("conversationID", isEqualTo: "\(users[0]!+users[1]!)")
        
        query.addSnapshotListener
            {
                (snapshot, error) in
                guard let snapshot = snapshot
                    else
                {
                    print("Error: \(error?.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if snapshot.documents.isEmpty == false
                {
                    for i in snapshot.documents
                    {
                        print(i)
                    }
                    completion(snapshot.documents.count)
                }
                else
                {
                    print("its empty")
                    completion(nil)
                }
        }
    }
    
    
    func createOneToOneConvo(conversation:Conversation?,completion:@escaping(Conversation?,Bool?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        let conversation1 = Conversation(conversationID: conversation!.conversationID!, dateCreated: conversation!.dateCreated!, users: conversation!.users!, convoName: conversation?.convoName!, convoLastMessage: conversation?.convoLastMessage!, convoLastMessageTime: conversation?.convoLastMessageTime!)
        
        ref = self.db.collection("conversation").document("\(conversation1.users![0]+conversation1.users![1])")
        
        let dataDic:[String:Any] = [
            "conversationID":"\(conversation1.users![0]+conversation1.users![1])",
            "dateTimeCreated":"\(conversation1.dateCreated!)",
            "users":conversation1.users,
            "conversationName":"\(conversation1.convoName)",
            "conversationLastMessage":"\(conversation1.convoLastMessage)",
            "conversationLastMessageTime":"\(conversation1.convoLastMessageTime)"
        ]
        
        ref?.setData(dataDic, completion:
            {
                (error) in
                if let err = error
                {
                    print(err.localizedDescription)
                    completion(nil,false,err.localizedDescription)
                }
                else
                {
                    print("conversation created")
                    completion(conversation,true,nil)
                }
            })
    }
    
    func getConversations(completion:@escaping([String?]?,String?)->Void)
    {
        
        var ref = self.db.collection("Users")
        
        let query = ref.whereField("uid", isEqualTo: self.delegate.currentUser!.uid!)
        
        query.addSnapshotListener
            {
                (snapshot, error) in
                
                guard let snapshot = snapshot else
                {
                    print("Error: \(error?.localizedDescription)")
                    completion(nil,error?.localizedDescription)
                    return
                }
                
                self.convoList = []
                
                for i in snapshot.documents
                {
                    let tmpArray = i.data()["conversations"] as! Any
                    print(tmpArray)
                    self.convoList = tmpArray as! [String?]
                    completion(self.convoList,nil)
                }
            }
    }
    
//    func getConvoUsers(convoID:String?,completion:@escaping([Conversation?]?,String?)->Void)
//    {
//        var ref = self.db.collection("conversation")
//
//        let fetchUsers = ref.whereField("conversationID", isEqualTo: convoID!)/*("conversations", arrayContains: "\(convoID!)")*/
//
//        print(convoID!)
//        fetchUsers.addSnapshotListener{
//            (snapshot, error) in
//            guard let snapshot = snapshot else
//                {
//                    print("Error: \(error?.localizedDescription)")
//                    completion(nil,error?.localizedDescription)
//                    return
//                }
//
//                self.conversations = []
//
//                for i in snapshot.documents
//                {
//                    let tmpConvo = Conversation(conversationID: i.data()["conversationID"] as! String, dateCreated: i.data()["dateTimeCreated"] as! String, users: i.data()["users"] as! [String])
//
//                        self.conversations.append(tmpConvo)
//                }
//                completion(self.conversations , nil)
//        }
//    }
}
