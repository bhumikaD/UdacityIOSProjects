//
//  ViewController.swift
//  PickYourPitch
//
//  Created by bhumika dwivedi on 6/18/17.
//  Copyright © 2017 bhumika dwivedi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
   
    // MARK: Properties
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var shouldSegueToSoundPlayer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.recordButton.isEnabled = true
        self.stopRecordingButton.isHidden = true
        self.recordingStatusLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func recordVoice(_ sender: Any) {
        
        //Update the UI
        self.stopRecordingButton.isHidden = false
        self.recordButton.isEnabled = false
        self.recordingStatusLabel.isHidden = false
        self.recordingStatusLabel.text = "Recording..."
        
        //Setup Audio Session
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        }catch _{
        
        }
        
        let fileName = "userVoice.wav"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathArray = [dirPath, fileName]
        
        let fileURL = URL(string: pathArray.joined(separator: "/"))
        
        do {
            // Initialize and prepare the recorder
            audioRecorder = try AVAudioRecorder(url: fileURL!, settings: [String: AnyObject]())
        } catch _ {
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true;
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
        // This function stops the audio. We will then wait to hear back from the recorder,
        // through the audioRecorderDidFinishRecording method
    }
    
    
    // MARK: Audio Recorded
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            self.recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.pathExtension)
            
            self.performSegue(withIdentifier: "stopRecording", sender: self)
        } else {
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopRecordingButton.isHidden = true
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlayPitchViewController = segue.destination as! PlayPitchViewController
            let data = recordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

   }

