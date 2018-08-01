//
//  KKControls.swift
//  AC Music
//
//  Created by Evan David on 6/26/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
import MediaPlayer


public class KKControls:NSViewController {
    
    
    @IBOutlet var songTitle: NSTextField!
    var timer : Timer? // To check to see if text field needs changing
    
    func startTimer() {
        if timer == nil {
            //star the timer!
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeSongTitle), userInfo: nil, repeats: true)
        }
    }
    
    
    
    @objc func changeSongTitle() {
        //Changes text in textbox to current song playing
        let asset = AVAsset(url: TheViewController.url!)
        let titleItems = AVMetadataItem.metadataItems(from: asset.metadata, filteredByIdentifier: AVMetadataIdentifier.commonIdentifierTitle)
        songTitle.stringValue = titleItems.last?.stringValue ?? "Song title??"
        
    }
    
    @IBAction func changeKKSong(_ sender: NSButton) {
        TheViewController.numKK = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Int(arc4random_uniform(74) + 1) : Int(arc4random_uniform(36) + 1)
        TheViewController.url = (SelectAGame.defaults.bool(forKey: "kkAircheck?")) ? Bundle.main.url(forResource: "kkac/\(TheViewController.numKK)", withExtension: "mp3") : Bundle.main.url(forResource: "kk/\(TheViewController.numKK)", withExtension: "mp3")
        SelectAGame().prefChangeSong()
        changeSongTitle()
        
    }
    
    
    @IBAction func closeButton(_ sender: NSButton) {
        view.window?.close()
        if timer != nil {
            //Stop checking text field when the view is closed
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        changeSongTitle() //Loads current song playing in textbox
        startTimer() //Have text field update every 5 seconds
    }
    
}
