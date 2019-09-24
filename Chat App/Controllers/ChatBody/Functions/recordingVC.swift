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
    
    //MARK: -Variables
    var soundPlayer : AVAudioPlayer!
    var uniqueID : String?
    var isPlaying : Bool = false
    var pauseTime : Double? = 0
    
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
        
    }
    
    //MARK: -Functions
    
    override func viewDidLayoutSubviews() {
        let height = playBtnOutlet.layer.frame.height
        playBtnOutlet.layer.cornerRadius = height/2
        backgroundMainView.layer.cornerRadius = 25
    }
    
    override func viewDidLoad() {
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
        
        print(Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioProgress), userInfo: nil, repeats: true))
    }
    
    @objc func updateAudioProgress()
    {
        if soundPlayer.isPlaying
        {
            audioTimeBar.setProgress(Float(soundPlayer.currentTime/soundPlayer.duration), animated: true)
        }
    }
    
    func togglePlaying()
    {
        if isPlaying == true
        {
            if pauseTime == 0.0
            {
                soundPlayer.play()
            }
            else
            {
                soundPlayer.play(atTime: pauseTime!)
            }
            playBtnOutlet.setImage(UIImage(named: "pause1"), for: .normal)
        }
        else
        {
            soundPlayer.pause()
            print(pauseTime!)
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
            setAudioProgress()
            print(isPlaying)
            print(soundPlayer.duration)
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
