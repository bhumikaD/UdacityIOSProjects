//
//  PlayPitchViewController.swift
//  PickYourPitch
//
//  Created by bhumika dwivedi on 6/18/17.
//  Copyright © 2017 bhumika dwivedi. All rights reserved.
//

import UIKit
import AVFoundation

class PlayPitchViewController: UIViewController {
    //MARK : IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pitchSlider: UISlider!
    
    let SliderValueKey = "Slider Value Key"
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        }
        catch _
        {
        
        }
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        do{
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        }
        catch _ {
            audioFile = nil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUserInterfaceToPlayMode(false)
        
    let value = UserDefaults.standard.float(forKey: "pitchValue")
      
        
        pitchSlider.setValue(value, animated: false)
        
    
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func playVoice(_ sender: Any) {
        
        // Get the pitch from the slider
        let pitch = pitchSlider.value
        
        // Play the sound
        playAudioWithVariablePitch(pitch)
        
        // Set the UI
        setUserInterfaceToPlayMode(true)
    }

    @IBAction func pitchSelected(_ sender: Any) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
    }
    
    // MARK: Set Interface
    
    func setUserInterfaceToPlayMode(_ isPlayMode: Bool) {
        playButton.isHidden = isPlayMode
        stopButton.isHidden = !isPlayMode
        pitchSlider.isEnabled = !isPlayMode
    }
    
    
    @IBAction func stopSound(_ sender: Any) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    @IBAction func pitchChanged(_ sender: Any) {
        print("Slider vaue: \(pitchSlider.value)")
        persistSliderPreference()
       
    }
    @IBAction func playSound(_ sender: Any) {
        
        // Get the pitch from the slider
        let pitch = pitchSlider.value
        
        // Play the sound
        playAudioWithVariablePitch(pitch)
        
        // Set the UI
        setUserInterfaceToPlayMode(true)
    }
    
    
    func playAudioWithVariablePitch(_ pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            // When the audio completes, set the user interface on the main thread
            DispatchQueue.main.async {self.setUserInterfaceToPlayMode(false) }
        }
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    func persistSliderPreference(){
    
     UserDefaults.standard.set(pitchSlider.value, forKey: "pitchValue")
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
