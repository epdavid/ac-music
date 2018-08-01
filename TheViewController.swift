//
//  TheViewController.swift
//  AC Music
//
//  Created by Evan David on 6/5/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa
import AVFoundation
import MediaPlayer
import Foundation
import AudioKit

public class TheViewController: NSViewController, AVAudioPlayerDelegate, NSUserNotificationCenterDelegate {
    
    var hour = Calendar.autoupdatingCurrent.component(.hour, from: Date())
    static var url:URL?
    static var numKK:Int = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Int(arc4random_uniform(74) + 1) : Int(arc4random_uniform(36) + 1)
    static var audioPlayer:AVAudioPlayer!
    var keepPlaying:Bool = false
    var inKK:Bool = false
    var enterKK:Bool = false
    var kkShouldKeepGoing:Bool = false
    static var game:String = (SelectAGame.defaults.string(forKey: "game") != nil) ? SelectAGame.defaults.string(forKey: "game")! : "nl"
    let sampler = AKAppleSampler()
    let ms: UInt32 = 1000 //For converting usleep times to milliseconds
    static var tune = (TownTuneEditor.defaults.object(forKey: "tune") != nil) ? TownTuneEditor.defaults.object(forKey: "tune") as! [Int] : TownTuneEditor.defaultTune
    let randNotes = [19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40]
    
   //Always show the notification. 
    @discardableResult public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
     //What the audio player does whenever a song successfully finishes (does not apply to looped tracks, pretty much only KK)
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        TheViewController.numKK = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Int(arc4random_uniform(74) + 1) : Int(arc4random_uniform(36) + 1)
        TheViewController.url = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Bundle.main.url(forResource: "kkac/\(TheViewController.numKK)", withExtension: "mp3") : Bundle.main.url(forResource: "kk/\(TheViewController.numKK)", withExtension: "mp3")
        keepPlaying = true
        kkShouldKeepGoing = true
        updateMusic()
    }
    
    //Startup stuff
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let hour = Calendar.autoupdatingCurrent.component(.hour, from: Date())
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        
        do {
            TheViewController.audioPlayer = try AVAudioPlayer(contentsOf: TheViewController.url!)
            TheViewController.audioPlayer.prepareToPlay()
            TheViewController.audioPlayer.currentTime = 0 //Starts at beginning of song
            TheViewController.audioPlayer.numberOfLoops = -1 //Loops infinitely
            TheViewController.audioPlayer.volume = SelectAGame.defaults.float(forKey: "volume") //Recalls user def. volume
            TheViewController.audioPlayer.delegate = self as AVAudioPlayerDelegate
            
            Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(TheViewController.updateMusic), userInfo: nil, repeats: true) //Checks every 15 seconds to make sure the right song is playing
            
        } catch {
            print("Where is my URL??")
        }
        do{
            try sampler.loadWav("clockChimes")
        } catch{print("whereThatFile?")}
        sampler.amplitude = 0.50
        let mix = AKMixer(sampler)
        AudioKit.output = mix
        try! AudioKit.start()
    }
    
    
    //Function that updates the music
    @objc func updateMusic() {
        var day:Int = Calendar(identifier: .gregorian).component(.weekday, from: Date())
        var hour:Int = Calendar.autoupdatingCurrent.component(.hour, from: Date())
        var minute:Int = Calendar.autoupdatingCurrent.component(.minute, from: Date())
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        
        
        func checkKK() -> Bool {
            //checks to see if it"s saturday night between 8:00 and 11:59 AND KK is enabled
            if ((day == 7 && (hour >= 20 && hour <= 23)) && (SelectAGame.defaults.integer(forKey: "enableKK") == 1)){
                return true
            }
            else {
                return false
            }
        }
        
        // KK Check
        if (checkKK() && !inKK){
            // need to start playing KK
            inKK = true
            enterKK = true
            keepPlaying = true
        }
        else if (!checkKK() && inKK){
            // need to stop playing KK
            inKK = false
            enterKK = false
            keepPlaying = false
        }
        
        //does nothing if no music is playing (unless keepPlaying is turned on, i.e., during KK)
        if (keepPlaying) {
            
        } else if (!(TheViewController.audioPlayer.isPlaying)){
            TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
            if ((TheViewController.url != TheViewController.audioPlayer.url) && !inKK) {
                do{
                    TheViewController.audioPlayer = try AVAudioPlayer(contentsOf: TheViewController.url!)
                    TheViewController.audioPlayer.prepareToPlay()
                    TheViewController.audioPlayer.setVolume(1.0, fadeDuration: 1.0)
                    TheViewController.audioPlayer.currentTime = 0
                    TheViewController.audioPlayer.numberOfLoops = -1
                } catch{print("??")}
            }
            return
        }
        
        if inKK {
            TheViewController.url = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Bundle.main.url(forResource: "kkac/\(TheViewController.numKK)", withExtension: "mp3") : Bundle.main.url(forResource: "kk/\(TheViewController.numKK)", withExtension: "mp3")
        }
            
        if (TheViewController.url != TheViewController.audioPlayer.url){
            //KK!!
            if (inKK) {
                TheViewController.numKK = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Int(arc4random_uniform(74) + 1) : Int(arc4random_uniform(36) + 1)
                TheViewController.url = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Bundle.main.url(forResource: "kkac/\(TheViewController.numKK)", withExtension: "mp3") : Bundle.main.url(forResource: "kk/\(TheViewController.numKK)", withExtension: "mp3")
              
                func showKKNotification() -> Void {
                    //Set up + display KK's Notification
                    
                    let notification = NSUserNotification()
                    notification.identifier = "unique-id2"
                    notification.title = "Animal Crossing Music"
                    notification.subtitle = "KK Slider has begun to play!"
                    notification.contentImage = NSImage(named:NSImage.Name("kkSlider"))
                    
                    let notificationCenter = NSUserNotificationCenter.default
                    
                    if enterKK {
                        notificationCenter.removeAllDeliveredNotifications()
                        enterKK = false
                    }
                    notificationCenter.deliver(notification)
                }
                
                func fadeOut(completion: @escaping () -> Void) {
                    TheViewController.audioPlayer.setVolume(0.0, fadeDuration: 3.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        TheViewController.audioPlayer.stop()
                        completion()
                    }
                }
                
                func playKK() {
                    do{
                        TheViewController.audioPlayer = try AVAudioPlayer(contentsOf: TheViewController.url!)
                        TheViewController.audioPlayer.prepareToPlay()
                        TheViewController.audioPlayer.setVolume(1.0, fadeDuration: 1.0)
                        TheViewController.audioPlayer.currentTime = 0
                        TheViewController.audioPlayer.delegate = self as AVAudioPlayerDelegate
                        TheViewController.audioPlayer.numberOfLoops = 0
                        TheViewController.audioPlayer.play()
                        if (SelectAGame.defaults.integer(forKey: "enableNotifications") == 1) {
                            showKKNotification()
                        }
                    } catch {}
                }
                
                //Actually starts up KK (after current song fades out)
                if (TheViewController.audioPlayer.isPlaying || kkShouldKeepGoing) {
                    fadeOut(completion: playKK)
                }
            }
            
            //It's not KK, just switch songs since the hour changed
            else {
                hour = Calendar.autoupdatingCurrent.component(.hour, from: Date())
                TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
                
                //Notification Function
                func showNotification() -> Void {
                    // get the current date and time
                    let currentDateTime = Date()
                    
                    // initialize the date formatter and set the style
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    formatter.dateStyle = .none
                    let theTime = formatter.string(from: currentDateTime)
                    
                    // set up notification
                    let notification = NSUserNotification()
                    notification.identifier = "unique-id"
                    notification.title = "Animal Crossing Music"
                    notification.subtitle = "It is now \(theTime)!"
                    
                    let notificationCenter = NSUserNotificationCenter.default
                    
                    notificationCenter.removeAllDeliveredNotifications() // removes old notifications
                    notificationCenter.deliver(notification) //deliver notification
                    notificationCenter.delegate = self as NSUserNotificationCenterDelegate
                    userNotificationCenter(notificationCenter, shouldPresent: notification)
                    
                }
                
                // Initializes new song; played after delay in fadeOut
                func startUpSong() {
                    do{
                        TheViewController.audioPlayer = try AVAudioPlayer(contentsOf: TheViewController.url!)
                        TheViewController.audioPlayer.prepareToPlay()
                        TheViewController.audioPlayer.setVolume(1.0, fadeDuration: 1.0)
                        TheViewController.audioPlayer.currentTime = 0
                        TheViewController.audioPlayer.numberOfLoops = -1
                        TheViewController.audioPlayer.play()
                        //audioPlayer.delegate = self as! AVAudioPlayerDelegate
                        if (SelectAGame.defaults.integer(forKey: "enableNotifications") == 1){
                            showNotification()
                        }
                    } catch {}
                }
                
                //Fades out music in 3 seconds, waits two more seconds, then plays startUpSong
                //Note the notation below for closure/callback
                func fadeOut(completion: @escaping () -> Void) {
                    TheViewController.audioPlayer.setVolume(0.0, fadeDuration: 3.0)
                    
                    //Plays tune on the hour if tune is enabled. Otherwise just starts up next song after the fade out.
                    if ((TownTuneEditor.defaults.integer(forKey: "tuneEnabled") != 0) && (minute <= 5)) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            TheViewController.audioPlayer.stop()
                            TheViewController.tune = (TownTuneEditor.defaults.object(forKey: "tune") != nil) ? TownTuneEditor.defaults.object(forKey: "tune") as! [Int] : TownTuneEditor.defaultTune
                            for note in TheViewController.tune {
                                if (note == 0) {
                                    usleep(600 * self.ms)
                                }
                                else if (note == 1){
                                    try! self.sampler.play(noteNumber: MIDINoteNumber(self.randNotes[Int(arc4random_uniform(13))] + 24))
                                    usleep(600 * self.ms)
                                }
                                else {
                                    try! self.sampler.play(noteNumber: MIDINoteNumber(note + 24))
                                    usleep(600 * self.ms)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                                TheViewController.audioPlayer.stop()
                                completion()
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                            TheViewController.audioPlayer.stop()
                            completion()
                        }
                    }
                }
                
                //Actually starts up the new song (after current song fades out)
                fadeOut(completion: startUpSong)
                
            }
        }
    }
}

//The thing that makes the window go away when you switch apps
extension TheViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TheViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "TheViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TheViewController else {
            fatalError("Why cant i find TheViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

//Play and stop buttons
extension TheViewController {
    @IBAction func play(_ sender: NSButton) {
        TheViewController.audioPlayer.play()
        updateMusic()
        if inKK {
            keepPlaying = true
        }
    }
    
    @IBAction func stop(_ sender: NSButton) {
        TheViewController.audioPlayer.stop()
        TheViewController.audioPlayer.currentTime = 0
        keepPlaying = false
        kkShouldKeepGoing = false
    }
}






