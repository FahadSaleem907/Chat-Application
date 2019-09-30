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
        
        let message1 = Message(type: message!.type!, uid: message!.uid, dateTime: message!.dateTime!, date: message!.date!, time: message!.time!, conversationID: message!.conversationID!, incoming: true, message: message!.message!)
        
        let dataDic : [String:Any] = [
                                        "msgType":"\(message1.type!)",
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
                        let tmpMessage = Message(type: j.data()["msgType"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                        
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
        //var ref:DocumentReference? = nil
        var tmpArray = [Message]()
        let query = self.db.collection("Messages").whereField("conversationID", isEqualTo: convoID!)
        
        print(convoID!)
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
                    let tmpMessage = Message(type: j.data()["msgType"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                    
                    tmpArray.append(tmpMessage)
                }
                completion(tmpArray,nil)
        })
    }
    
    func getPaginatedOneToOneMsgs(convoID:String?,completion:@escaping([Message?]?,String?)->Void)
    {
        //var ref:DocumentReference? = nil
        var tmpArray = [Message]()
        let queryFirst = self.db.collection("Messages").whereField("conversationID", isEqualTo: convoID!).order(by: "dateTime").limit(to: 5)
        
        queryFirst.addSnapshotListener(
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
                    let tmpMessage = Message(type: j.data()["msgType"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                    
                    print(tmpArray)
                    
                    tmpArray.append(tmpMessage)
                }
                completion(tmpArray,nil)
                
                guard let lastSnapshot = snapshot.documents.last else
                {
                    return
                }
                
                let nextMessagesBatch = self.db.collection("Messages").whereField("conversationID", isEqualTo: convoID!).order(by: "dateTime").start(afterDocument: lastSnapshot)
                
                nextMessagesBatch.addSnapshotListener({ (nextSnapshot, error) in
                    guard let nextSnapshot = nextSnapshot else
                    {
                        print("Error : \(error!.localizedDescription)")
                        completion(tmpArray,error!.localizedDescription)
                        
                        print(tmpArray)
                        return
                    }
                    
                    for j in nextSnapshot.documents
                    {
                        let tmpMessage = Message(type: j.data()["msgType"] as? String, uid: j.data()["uid"] as? String, dateTime: j.data()["dateTime"] as? String, date: j.data()["date"] as? String, time: j.data()["time"] as? String, conversationID: "\(convoID!)", incoming: true, message: j.data()["message"] as? String)
                        
                        tmpArray.append(tmpMessage)
                    }
                    print(tmpArray)
                    completion(tmpArray,nil)
                })
                
        })
    }
    
    func uploadMsgImg(convoID:String?,image:UIImage?,completion:@escaping(_ url:String?,_ error:String?)->Void)
    {
        let storageRef:StorageReference!
        storageRef = Storage.storage().reference()
        
        let uuid = UUID().uuidString
        let storageFile = storageRef.child("MessageImage").child("\(convoID!)").child(uuid)
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
                print("ERROR : \(error!.localizedDescription)")
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
    
    func uploadAudioMsg(convoID:String?, audioPath:String?,completion:@escaping(_ url:URL?,_ error:String?)->Void)
    {
        let storageRef:StorageReference!
        storageRef = Storage.storage().reference()
        
        let uuid = UUID().uuidString
        let storageFile = storageRef.child("MessageAudios").child("\(convoID!)").child(uuid)
        
        storageFile.putFile(from: URL(string: audioPath!)!, metadata: nil)
        {
            (metaData, error) in
            if let err = error
            {
                print(err.localizedDescription)
                completion(nil,err.localizedDescription)
            }
            else
            {
                storageFile.downloadURL { (url, error) in
                    if let err = error
                    {
                        print(err.localizedDescription)
                        completion(nil,err.localizedDescription)
                    }
                    else
                    {
                        completion(url,nil)
                    }
                }
            }
        }
    }
    
    func deleteMessage()
    {
        
    }
}
