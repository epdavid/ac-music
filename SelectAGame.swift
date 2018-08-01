//
//  SelectAGame.swift
//  AC Music
//
//  Created by Evan David on 6/13/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
import MediaPlayer

public class SelectAGame: NSViewController {
    var hour:Int = Calendar.autoupdatingCurrent.component(.hour, from: Date())
    static let defaults = UserDefaults.standard
    @IBOutlet weak var gameImage: NSImageView!
    @IBOutlet weak var characterImage: NSImageView!
    var day:Int = Calendar(identifier: .gregorian).component(.weekday, from: Date())
    
    @IBOutlet var openKKControls: NSButton!
    
    @IBOutlet var enableNotifications: NSButton!
    
    @IBAction func enableNotificationsButton(_ sender: NSButton) {
        SelectAGame.defaults.set(enableNotifications.state.rawValue, forKey: "enableNotifications")
    }
    
    //KK Controls
    @IBOutlet var enableKK: NSButton!
    @IBOutlet var kkLive: NSButton!
    @IBOutlet var kkAircheck: NSButton!
 
    @IBAction func enableKKButton(_ sender: NSButton) {
        SelectAGame.defaults.set(enableKK.state.rawValue, forKey: "enableKK")
        if enableKK.state.rawValue == 1 {
            kkLive.isEnabled = true
            kkAircheck.isEnabled = true
        }
        else if enableKK.state.rawValue == 0 {
            kkLive.isEnabled = false
            kkAircheck.isEnabled = false
        }
    }
    
    @IBAction func kkSelectionChanged(_ sender: AnyObject) {
        if (kkLive.state.rawValue == 1) {
            SelectAGame.defaults.set(false, forKey: "kkAircheck?")
        }
        else if (kkAircheck.state.rawValue == 1) {
            SelectAGame.defaults.set(true, forKey: "kkAircheck?")
        }
    }
    
    @IBOutlet var volume: NSSlider!
    @IBAction func volumeControl(_ sender: NSSlider) {
        TheViewController.audioPlayer.volume = volume.floatValue
        SelectAGame.defaults.set(volume.floatValue, forKey: "volume")
    }
    
    
    let characters:[NSImage] = [NSImage(named:NSImage.Name("isabelle"))!, NSImage(named:NSImage.Name("blathers"))!, NSImage(named:NSImage.Name("kkSlider"))!, NSImage(named:NSImage.Name("tomnook"))!, NSImage(named:NSImage.Name("mrresetti"))!]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        prefChangeImage()
        randCharacterImage()
        enableKK.state = NSControl.StateValue(rawValue: SelectAGame.defaults.integer(forKey: "enableKK"))
        enableNotifications.state = NSControl.StateValue(rawValue: SelectAGame.defaults.integer(forKey: "enableNotifications"))
        if enableKK.state.rawValue == 1 {
            if (SelectAGame.defaults.bool(forKey: "kkAircheck?")) {
                kkLive.state = NSControl.StateValue.off
                kkAircheck.state = NSControl.StateValue.on
            }
            else {
                kkLive.state = NSControl.StateValue.on
                kkAircheck.state = NSControl.StateValue.off
            }
        }
        else {
            kkLive.isEnabled = false
            kkAircheck.isEnabled = false
        }
        
        
        openKKControls.isEnabled = (enableKK.state.rawValue == 1 && (day == 7 && (hour >= 20 && hour <= 23))) ? true : false
        
        
        volume.floatValue = SelectAGame.defaults.float(forKey: "volume")
    }
    
    func randCharacterImage() {
        characterImage.image = characters[Int(arc4random_uniform(5))]
    }
    
    func prefChangeImage() {
        switch TheViewController.game {
        case "nl":
            gameImage.image = NSImage(named:NSImage.Name("newleaflogo"))
        case "ww":
            gameImage.image = NSImage(named:NSImage.Name("cityfolklogo"))
        case "ac":
            gameImage.image = NSImage(named:NSImage.Name("animalcrossinglogo"))
        case "nlrn":
            gameImage.image = NSImage(named:NSImage.Name("newleafrainlogo"))
        default:
            gameImage.image = NSImage(named:NSImage.Name("newleaflogo"))
        }
    }
    
    func prefChangeSong() {
        do{
            TheViewController.audioPlayer = try AVAudioPlayer(contentsOf: TheViewController.url!)
            TheViewController.audioPlayer.prepareToPlay()
            TheViewController.audioPlayer.setVolume(1.0, fadeDuration: 1.0)
            TheViewController.audioPlayer.currentTime = 0
            TheViewController.audioPlayer.numberOfLoops = -1
            TheViewController.audioPlayer.play()
        } catch{}
    }
    
    
    @IBAction func animalCrossing(_ sender: NSButton) {
        TheViewController.game = "ac"
        SelectAGame.defaults.set("ac", forKey: "game")
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        TheViewController.audioPlayer.stop()
        prefChangeSong()
        prefChangeImage()
    }
    
    @IBAction func wildWorld(_ sender: NSButton) {
        TheViewController.game = "ww"
        SelectAGame.defaults.set("ww", forKey: "game")
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        TheViewController.audioPlayer.stop()
        prefChangeSong()
        prefChangeImage()
    }
    
    @IBAction func newLeaf(_ sender: NSButton) {
        TheViewController.game = "nl"
        SelectAGame.defaults.set("nl", forKey: "game")
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        TheViewController.audioPlayer.stop()
        prefChangeSong()
        prefChangeImage()
    }
    
    
    @IBAction func newLeafRainy(_ sender: NSButton) {
        TheViewController.game = "nlrn"
        SelectAGame.defaults.set("nlrn", forKey: "game")
        TheViewController.url = Bundle.main.url(forResource: "\(TheViewController.game)/\(hour)", withExtension: "mp3")
        TheViewController.audioPlayer.stop()
        prefChangeSong()
        prefChangeImage()
    }
    
    
    
    @IBAction func close(_ sender: NSButton) {
        view.window?.close()
    }
    
    
    @IBAction func quitApp(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
