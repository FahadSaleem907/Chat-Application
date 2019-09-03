//
//  conversationFunctions.swift
//  Chat App
//
//  Created by Fahad Saleem on 9/2/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class conversationFunctions
{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var db = Firestore.firestore()
    
    func createConversation(conversation:Conversation?,completion:@escaping(Conversation?,Bool?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        let conversation1 = Conversation(conversationID: conversation!.conversationID!, dateCreated: conversation!.dateCreated!, users: conversation!.users!)
        
        ref = self.db.collection("conversation").document()
        
        let dataDic : [String:Any]  =   [
                                        "conversationID":"\(ref!.documentID)",
                                        "dateTimeCreated":"\(conversation1.dateCreated)",
                                        "users":[conversation1.users]
                                        ]
        
        ref?.setData(dataDic, completion:
            {
                (error) in
                if let err = error
                {
                    print("Error: \(err.localizedDescription)")
                    completion(nil,false,err.localizedDescription)
                }
                else
                {
                    print("conversation created")
                    completion(conversation,true,nil)
                }
            })
    }
    
    func getConversationID(users:[String]?,completion:@escaping(String?,String?)->Void)
    {
        let user1Ref = self.db.collection("conversations").whereField("users", arrayContains: "\(users![0])")
        let user2Ref = self.db.collection("conversations").whereField("users", arrayContains: "\(users![1])")
        let user3Ref = self.db.collection("conversations").whereField("users", arrayContains: "\(users![3])")
        
        user1Ref.addSnapshotListener
            {
                (snapshot, error) in
                
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                    completion(nil,error.localizedDescription)
                }
                else
                {
                    for i in snapshot!.documents
                    {
                        
                    }
                }
            }
    }
    
    func deleteConversation(conversationID:String?)
    {
        
    }
}
