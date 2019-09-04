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
    var conversationArray = [Conversation?]()
    var conversationDic = [String?:Int]()
    var selectedConvoID:String?
    var selectedConvoVal:Int?
    
    func createConversation(conversation:Conversation?,completion:@escaping(Conversation?,Bool?,String?)->Void)
    {
        var ref:DocumentReference? = nil
        
        let conversation1 = Conversation(conversationID: conversation!.conversationID!, dateCreated: conversation!.dateCreated!, users: conversation!.users!)
        
        ref = self.db.collection("conversation").document()
        
        let dataDic : [String:Any]  =   [
                                        "conversationID":"\(ref!.documentID)",
                                        "dateTimeCreated":"\(conversation1.dateCreated)",
                                        "users":conversation1.users
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
    
    func getConversationID(users:[String]?,completion:@escaping(String?,String?,Int?,Int?)->Void)
    {
        conversationDic = [:]

        for i in users!
        {
            let userRef = self.db.collection("conversation").whereField("users", arrayContains: i)
            
            userRef.addSnapshotListener
                {
                    (snapshot, error) in
                    
                    guard let snapshot = snapshot else
                    {
                        print("Error: \(error?.localizedDescription)")
                        completion(nil,error?.localizedDescription,nil,nil)
                        return
                    }
                    
                    for j in snapshot.documents
                    {
                        let value = j.data()["conversationID"] as! String
                        
                        if self.conversationDic.keys.contains(value) == true
                        {
                            var tmpVal = self.conversationDic["\(value)"]
                            tmpVal = tmpVal! + 1
                            self.conversationDic.updateValue(tmpVal!, forKey: value)
                        }
                        else
                        {
                            self.conversationDic.updateValue(1, forKey: value)
                        }
                        
                        let convoID = self.conversationDic.sorted(by:
                        {
                            (a, b) -> Bool in
                            return a.value > b.value
                        })
                        
                        self.selectedConvoID = convoID.first!.key
                        self.selectedConvoVal = convoID.first!.value
                    }
                    completion(self.selectedConvoID!,nil,users!.count,self.selectedConvoVal!)
            }
        }
        
    }
    
    
    func getConversations(completion:@escaping([Conversation?]?,String?)->Void)
    {
        let fetchConvos = self.db.collection("conversation")
        
        fetchConvos.addSnapshotListener
            {
                (snapshot, error) in
                
                self.conversationArray = []
                
                guard let snapshot = snapshot
                else
                {
                    print("Error : \(error?.localizedDescription)")
                    completion(nil,error?.localizedDescription)
                    return
                }
                
                for i in snapshot.documents
                {
                    print(i)
                    let tmpConvo = Conversation(conversationID: i.data()["conversationID"] as! String, dateCreated: i.data()["dateTimeCreated"] as! String, users: i.data()["users"] as! [String]?)
                    
                    self.conversationArray.append(tmpConvo)
                }
                completion(self.conversationArray,nil)
        }
    }
    
    func deleteConversation(conversationID:String?)
    {
        
    }
}
