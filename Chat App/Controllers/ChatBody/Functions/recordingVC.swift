//
//  recordingVC.swift
//  Chat App
//
//  Created by Fahad Saleem on 9/24/19.
//  Copyright © 2019 SunnyMac. All rights reserved.
//

import UIKit
import AVFoundation

class recordingVC: UIViewController
{

    //MARK: -Constants
    let chat = chatVC()
    let messageServices = messageFunctions()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let oneToOneConvoServices = oneToOneConvoFunctions()
    
    //MARK: -Variables
    var soundPlayer : AVAudioPlayer!
    var uniqueID : String?
    var isPlaying : Bool = false
    var pauseTime : Double? = 0
    var dateAndTime : String?
    var dateOnly : String?
    var timeOnly : String?
    var convoID : String?
    var audioMsgUrl : String?
    
    //MARK: -Outlets
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var audioTimeBar: UIProgressView!
    
    @IBOutlet weak var playBtnOutlet: UIButton!
    
    //MARK: -Actions
    
    @IBAction func dismissBtn(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playBtn(_ sender: UIButton)
    {
        playAudio()
    }
    
    @IBAction func sendAudio(_ sender: UIButton)
    {
        if soundPlayer.isPlaying
        {
            soundPlayer.stop()
        }
        sendAudioMsg(conversationID: convoID!)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -Functions
    
    func getDateTime()
    {
        let dateTime = Date()
        let dateTimeFormat = DateFormatter()
        dateTimeFormat.dateStyle = .medium
        dateTimeFormat.timeStyle = .medium
        dateAndTime = dateTimeFormat.string(from: dateTime)
    }
    
    
    func getDate()
    {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .none
        dateOnly = dateFormat.string(from: date)
    }

    func getTime()
    {
        let time = Date()
        let timeFormat = DateFormatter()
        timeFormat.dateStyle = .none
        timeFormat.timeStyle = .medium
        timeOnly = timeFormat.string(from: time)
    }
    
    func sendAudioMsg(conversationID:String)
    {
        getDateTime()
        getDate()
        getTime()
        
        let url = chat.getDocumentsDirectory().appendingPathComponent("\(uniqueID!).m4a").absoluteString
        print(uniqueID!)
        
        messageServices.uploadAudioMsg(convoID: conversationID, audioPath: url)
        {
            (url, error) in
            
            guard let url = url else
            {
                print(error)
                return
            }
            
            self.audioMsgUrl = url.absoluteString
            
            let message1 = Message(type: "Audio", uid: self.delegate.currentUser!.uid!, dateTime: "\(self.dateAndTime!)", date: "\(self.dateOnly!)", time: "\(self.timeOnly!)", conversationID: self.convoID!, incoming: false, message: self.audioMsgUrl!)
            
            self.messageServices.createMessage(message: message1, ConvoID: self.convoID)
            {
                (message, success, error) in
                if success == true
                {
                    print("Sent Successfully: \(message!)")
                }
                else
                {
                    print(error!)
                }
            }
            
            self.oneToOneConvoServices.updateConvo(convoID: self.convoID!, msg: self.audioMsgUrl!, time: self.dateAndTime!)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        let height = playBtnOutlet.layer.frame.height
        playBtnOutlet.layer.cornerRadius = height/2
        backgroundMainView.layer.cornerRadius = 25
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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

extension recordingVC: AVAudioPlayerDelegate
{
    func setAudioProgress()
    {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioProgress), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateAudioProgress()
    {
        if soundPlayer.isPlaying
        {
            audioTimeBar.setProgress(Float(soundPlayer.currentTime/soundPlayer.duration), animated: true)
            
            print(soundPlayer.currentTime)
            
            if (soundPlayer.currentTime + 0.1) > soundPlayer.duration
            {
                audioTimeBar.progress = 0
                playBtnOutlet.setImage(UIImage(named: "play1"), for: .normal)
                isPlaying = !isPlaying
                pauseTime = 0.0
                soundPlayer.stop()
            }
        }
    }
    
    func togglePlaying()
    {
        if isPlaying == true
        {
            soundPlayer.play()
            setAudioProgress()
            
            playBtnOutlet.setImage(UIImage(named: "pause1"), for: .normal)
        }
        else
        {
            pauseTime = Double(audioTimeBar.progress) * soundPlayer.duration
            soundPlayer.pause()
            
            setAudioProgress()
            playBtnOutlet.setImage(UIImage(named: "play1"), for: .normal)
        }
    }
    
    func playAudio()
    {
        let path = chat.getDocumentsDirectory().appendingPathComponent("\(uniqueID!).m4a")
        print(uniqueID!)
        
        do
        {
            soundPlayer = try AVAudioPlayer(contentsOf: path)
            isPlaying = !isPlaying
            togglePlaying()
            getDuration(time: soundPlayer.duration)
        }
        catch
        {
            print("Doesnt ExisT")
        }
    }
    
    func getDuration(time:Double) -> String
    {
        if soundPlayer.duration > 60
        {
            let minutes = Int(soundPlayer.duration / 60)
            let seconds = soundPlayer.duration.remainder(dividingBy: 60)
            
            print(minutes)
            print(Int(seconds))
            
            let time = "\(minutes):\(Int(seconds))"
            if minutes < 10
            {
                durationLbl.text = "0\(time)"
            }
            else
            {
                durationLbl.text = time
            }
            return time
        }
        else
        {
            if soundPlayer.duration < 10
            {
                durationLbl.text = "00:0\(Int(soundPlayer.duration))"
            }
            else
            {
                durationLbl.text = "00:\(Int(soundPlayer.duration))"
            }
            return "00:\(Int(soundPlayer.duration))"
        }
//        return String(duration)
    }
}
