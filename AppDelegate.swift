//
//  AppDelegate.swift
//  AC Music
//
//  Created by Evan David on 6/5/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    
   
    
    
    var eventMonitor: EventMonitor?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if (SelectAGame.defaults.float(forKey: "volume") == 0) {
            SelectAGame.defaults.set(1.0, forKey: "volume")
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("icon40"))
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = TheViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    
  

}

