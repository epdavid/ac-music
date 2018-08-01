//
//  TownTuneEditor.swift
//  AC Music
//
//  Created by Evan David on 6/12/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Foundation
import Cocoa
import AudioKit


public class TownTuneEditor: NSViewController {
    let availablePitches = ["-", "??", "G1", "A1", "B1", "C2", "D2", "E2", "F2", "G2", "A2", "B2", "C3", "D3", "E3"]
    let availablePitchesMidi = [0, 1, 19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40]
    static let defaultTune = [31, 40, 0, 31, 29, 38, 0, 35, 36, 0, 1, 0, 24, 0, 0, 0]
    let randNotes = [19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40]
    
    static var tune:[Int?] = []
    
    let sampler = AKAppleSampler()
    
    let ms: UInt32 = 1000 //For converting usleep times to milliseconds
    
    static let defaults = UserDefaults.standard
    
    @IBOutlet var townTuneEnabled: NSButton!
    
    
    func preloadATune(tune: [Int]) {
        let sliders = [slider1,
                       slider2,
                       slider3,
                       slider4,
                       slider5,
                       slider6,
                       slider7,
                       slider8,
                       slider9,
                       slider10,
                       slider11,
                       slider12,
                       slider13,
                       slider14,
                       slider15,
                       slider16]
        
        let textFields = [noteValue1,
                          noteValue2,
                          noteValue3,
                          noteValue4,
                          noteValue5,
                          noteValue6,
                          noteValue7,
                          noteValue8,
                          noteValue9,
                          noteValue10,
                          noteValue11,
                          noteValue12,
                          noteValue13,
                          noteValue14,
                          noteValue15,
                          noteValue16]
        
        for (note, slider) in zip(tune, sliders) {
            if (note == 0) {
                slider!.doubleValue = 1
            }
            else {
                slider!.doubleValue = Double(availablePitchesMidi.index(of: note)! + 1)
            }
        }
        
        for (slider, text) in zip(sliders, textFields) {
            text!.stringValue = "\(availablePitches[(slider!.integerValue) - 1])"
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //Loads defaults for Town Tune Enabled
        townTuneEnabled.state = NSControl.StateValue(rawValue: TownTuneEditor.defaults.integer(forKey:"tuneEnabled"))
        
        //Loads default tune
        TownTuneEditor.tune = (TownTuneEditor.defaults.object(forKey: "tune") != nil) ? TownTuneEditor.defaults.object(forKey: "tune") as! [Int] : TownTuneEditor.defaultTune
        preloadATune(tune: TownTuneEditor.tune as! [Int])
        
        //Loads up the tune player
        do{
            try sampler.loadWav("bellTrimmed_15")
        } catch{print("whereThatFile?")}
        sampler.amplitude = 0.2
        let mix = AKMixer(sampler)
        AudioKit.output = mix
        try! AudioKit.start()
    }
    
    func playSomeNote(note: Int) {
        if (note > 1) {
            try! sampler.play(noteNumber: MIDINoteNumber(note + 36))
        }
    }
    
    
    
    func showSliderValueAsText(slider: NSSlider, note: NSTextField) {
        let sliderNote = availablePitches[(slider.integerValue) - 1]
        note.stringValue = "\(sliderNote)"
        
        if (availablePitchesMidi[(slider.integerValue) - 1] != 0){
            playSomeNote(note: availablePitchesMidi[(slider.integerValue) - 1])
        }
    }
    
    
    //Main Buttons
    @IBAction func playTheTuneButton(_ sender: NSButton) {
        
        let theNotes = [availablePitchesMidi[(slider1.integerValue) - 1],
                        availablePitchesMidi[(slider2.integerValue) - 1],
                        availablePitchesMidi[(slider3.integerValue) - 1],
                        availablePitchesMidi[(slider4.integerValue) - 1],
                        availablePitchesMidi[(slider5.integerValue) - 1],
                        availablePitchesMidi[(slider6.integerValue) - 1],
                        availablePitchesMidi[(slider7.integerValue) - 1],
                        availablePitchesMidi[(slider8.integerValue) - 1],
                        availablePitchesMidi[(slider9.integerValue) - 1],
                        availablePitchesMidi[(slider10.integerValue) - 1],
                        availablePitchesMidi[(slider11.integerValue) - 1],
                        availablePitchesMidi[(slider12.integerValue) - 1],
                        availablePitchesMidi[(slider13.integerValue) - 1],
                        availablePitchesMidi[(slider14.integerValue) - 1],
                        availablePitchesMidi[(slider15.integerValue) - 1],
                        availablePitchesMidi[(slider16.integerValue) - 1]]
        
        
        
        for note in theNotes {
            if (note == 0) {
                usleep(250 * ms)
            }
            else if (note == 1) {
                try! sampler.play(noteNumber: MIDINoteNumber(randNotes[Int(arc4random_uniform(13))] + 36))
                usleep(250 * ms)
            }
            else {
                try! sampler.play(noteNumber: MIDINoteNumber(note + 36))
                usleep(250 * ms)
            }
        }
    }
    
    
    @IBAction func saveButton(_ sender: NSButton) {
        let theNotes = [availablePitchesMidi[(slider1.integerValue) - 1],
                        availablePitchesMidi[(slider2.integerValue) - 1],
                        availablePitchesMidi[(slider3.integerValue) - 1],
                        availablePitchesMidi[(slider4.integerValue) - 1],
                        availablePitchesMidi[(slider5.integerValue) - 1],
                        availablePitchesMidi[(slider6.integerValue) - 1],
                        availablePitchesMidi[(slider7.integerValue) - 1],
                        availablePitchesMidi[(slider8.integerValue) - 1],
                        availablePitchesMidi[(slider9.integerValue) - 1],
                        availablePitchesMidi[(slider10.integerValue) - 1],
                        availablePitchesMidi[(slider11.integerValue) - 1],
                        availablePitchesMidi[(slider12.integerValue) - 1],
                        availablePitchesMidi[(slider13.integerValue) - 1],
                        availablePitchesMidi[(slider14.integerValue) - 1],
                        availablePitchesMidi[(slider15.integerValue) - 1],
                        availablePitchesMidi[(slider16.integerValue) - 1]]
        
        let townTuneState = townTuneEnabled.state.rawValue
        
        TownTuneEditor.defaults.set(theNotes, forKey:"tune")
        TownTuneEditor.defaults.set(townTuneState, forKey:"tuneEnabled")
        TheViewController.tune = TownTuneEditor.defaults.object(forKey: "tune") as! [Int]
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        view.window?.close()
    }
    
    
    
    //Preset Tune Buttons
    @IBAction func setDefaultTune(_ sender: NSButton) {
        preloadATune(tune: TownTuneEditor.defaultTune)
    }
    
    @IBAction func setMarioTune(_ sender: NSButton) {
        let marioTheme = [28, 28, 0, 28, 0, 24, 28, 0, 31, 0, 0, 0, 19, 0, 0, 0]
        preloadATune(tune: marioTheme)
    }
    
    @IBAction func setZeldaTune(_ sender: NSButton) {
        let zeldaTheme = [33, 0, 28, 0, 0, 33, 33, 35, 36, 38, 40, 0, 0, 0, 0, 0]
        preloadATune(tune: zeldaTheme)
    }
    
    @IBAction func setSpookyTune(_ sender: NSButton) {
        let spookyTune = [21, 0, 0, 23, 24, 0, 21, 0, 28, 0, 0, 0, 29, 0, 0, 0]
        preloadATune(tune: spookyTune)
    }
    
    @IBAction func setRandomTune(_ sender: NSButton) {
        let randomTune = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        preloadATune(tune: randomTune)
    }
    
    
    
    
    
    
    
    // Note Value Outlets
    @IBOutlet weak var noteValue1: NSTextField!
    @IBOutlet weak var noteValue2: NSTextField!
    @IBOutlet weak var noteValue3: NSTextField!
    @IBOutlet weak var noteValue4: NSTextField!
    @IBOutlet weak var noteValue5: NSTextField!
    @IBOutlet weak var noteValue6: NSTextField!
    @IBOutlet weak var noteValue7: NSTextField!
    @IBOutlet weak var noteValue8: NSTextField!
    @IBOutlet weak var noteValue9: NSTextField!
    @IBOutlet weak var noteValue10: NSTextField!
    @IBOutlet weak var noteValue11: NSTextField!
    @IBOutlet weak var noteValue12: NSTextField!
    @IBOutlet weak var noteValue13: NSTextField!
    @IBOutlet weak var noteValue14: NSTextField!
    @IBOutlet weak var noteValue15: NSTextField!
    @IBOutlet weak var noteValue16: NSTextField!
    
    // Slider Outlets
    @IBOutlet weak var slider1: NSSlider!
    @IBOutlet weak var slider2: NSSlider!
    @IBOutlet weak var slider3: NSSlider!
    @IBOutlet weak var slider4: NSSlider!
    @IBOutlet weak var slider5: NSSlider!
    @IBOutlet weak var slider6: NSSlider!
    @IBOutlet weak var slider7: NSSlider!
    @IBOutlet weak var slider8: NSSlider!
    @IBOutlet weak var slider9: NSSlider!
    @IBOutlet weak var slider10: NSSlider!
    @IBOutlet weak var slider11: NSSlider!
    @IBOutlet weak var slider12: NSSlider!
    @IBOutlet weak var slider13: NSSlider!
    @IBOutlet weak var slider14: NSSlider!
    @IBOutlet weak var slider15: NSSlider!
    @IBOutlet weak var slider16: NSSlider!
    
    // Slider Actions
    @IBAction func sliderChange1(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider1, note: noteValue1)
    }
    @IBAction func sliderChange2(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider2, note: noteValue2)
    }
    @IBAction func sliderChange3(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider3, note: noteValue3)
    }
    @IBAction func sliderChange4(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider4, note: noteValue4)
    }
    @IBAction func sliderChange5(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider5, note: noteValue5)
    }
    @IBAction func sliderChange6(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider6, note: noteValue6)
    }
    @IBAction func sliderChange7(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider7, note: noteValue7)
    }
    @IBAction func sliderChange8(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider8, note: noteValue8)
    }
    @IBAction func sliderChange9(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider9, note: noteValue9)
    }
    @IBAction func sliderChange10(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider10, note: noteValue10)
    }
    @IBAction func sliderChange11(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider11, note: noteValue11)
    }
    @IBAction func sliderChange12(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider12, note: noteValue12)
    }
    @IBAction func sliderChange13(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider13, note: noteValue13)
    }
    @IBAction func sliderChange14(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider14, note: noteValue14)
    }
    @IBAction func sliderChange15(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider15, note: noteValue15)
    }
    @IBAction func sliderChange16(_ sender: NSSlider) {
        showSliderValueAsText(slider: slider16, note: noteValue16)
    }
}
