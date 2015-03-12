//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Austen Johnson on 3/4/15.
//  Copyright (c) 2015 Austen Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowButton(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablerate(0.5)
    }

    @IBAction func fastButton(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablerate(1.5)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderSound(sender: UIButton) {
        stopAllAudio()
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariablerate(rate: Float) {
        stopAllAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    @IBAction func stopButton(sender: UIButton) {
        stopAllAudio()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // removes file once we change views
        
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        
        if fileManager.removeItemAtURL(receivedAudio.filePathUrl!, error: &error) {
            println("file deleted")
        } else {
            println("file not deleted")
        }
    }

     func stopAllAudio() {
        
        //creating a function to stop audio playing so I can keep from reusing same code
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
