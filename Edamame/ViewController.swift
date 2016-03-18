//
//  ViewController.swift
//  Edamame
//
//  Created by Ben Ha on 3/16/16.
//  Copyright © 2016 Ben Ha. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ViewController: UIViewController {
    var frequencyPlayer:AVAudioPlayer!
    var recordingSession:AVAudioSession!
    var recorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        /*
        Helper method to set up recorder
        */
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord);
            try recordingSession.setActive(true);
            recordingSession.requestRecordPermission({(allowed: Bool) -> Void in
                if(allowed){
                    self.loadSuccessUI();
                    
                    
                }else{
                    self.loadFailUi();
                }
            })
        }catch{
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startRecording(sender: AnyObject)
    {
        self.record()
    }
    /*
    Starts and set up recording
    */
    func record(){
        // Set up
        var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        var fileName = documents.stringByAppendingPathComponent("recordTest.caf")
        let url = NSURL.fileURLWithPath(fileName as String)
        let setting=[
            AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey:12000.0,
            AVNumberOfChannelsKey:1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            
        ]
        do{
            // Start recording
            recorder = try AVAudioRecorder(URL: url, settings: setting)
            // Need to enable the retrieval of info from recorder
            recorder.meteringEnabled = true
            frequencyPlayer = self.frequencySweep("frequency_sweep", type: "wav")
            frequencyPlayer.volume = 1.0
            frequencyPlayer.play()
            recorder.record()
            
            print("record start success")
            print(recorder.averagePowerForChannel(0))
        }catch{
            print("record start fail")
        }
    }
    func frequencySweep(file:NSString, type:NSString) -> AVAudioPlayer{
        var audioPlayer:AVAudioPlayer!;
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String);
        let url = NSURL.fileURLWithPath(path!)
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }catch{
            print("Frequency player not available");
        }
        return audioPlayer;
        
    }
    
    
    @IBAction func printDecibel(sender: AnyObject) {
        // Need to call update meter before retreiving any info from recorder
        recorder.updateMeters();
        print(recorder.averagePowerForChannel(0))
    }
    @IBAction func stopRecording(sender: AnyObject) {
        recorder.stop()
    }
    
    func loadSuccessUI(){
        print("Succesful permision to record")
        
    }
    func loadFailUi(){
        print("Unsuccesful permission to record")
    }
    
}

