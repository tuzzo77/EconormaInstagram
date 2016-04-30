//
//  InterfaceController.swift
//  EconormaInstagram WatchKit App Extension
//
//  Created by Alessandro Mattiuzzi MacPro on 29/04/16.
//  Copyright © 2016 Alessandro Mattiuzzi MacPro. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var labelWatch: WKInterfaceLabel!
    @IBOutlet var imageWatch: WKInterfaceImage!
    var session:WCSession!
  
    var sensors = [String]()
    var desSensors = [String]()
    var dateStr = [String]()
    var temp = [String]()
    var channel = [String]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pushMeAction() {
        if(WCSession.isSupported()){
            session.sendMessage(["b":"goodBye"], replyHandler: nil, errorHandler: nil)
        }
        
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if let retrievedSensors = applicationContext["sensor"] as? [String] {
                
                self.sensors = retrievedSensors
                
                print(self.sensors)
                
            }
            
            if let retrievedDescription = applicationContext["description"] as? [String] {
                
                self.desSensors = retrievedDescription
                
                print(self.desSensors)
                
            }
            
            if let retrievedDate = applicationContext["date"] as? [String] {
                
                self.dateStr = retrievedDate
                
                print(self.dateStr)
                
            }
            
            if let retrievedTemp = applicationContext["temp"] as? [String] {
                
                self.temp = retrievedTemp
                
                print(self.temp)
                
            }
            
            if let retrievedChannel = applicationContext["channel"] as? [String] {
                
                self.channel = retrievedChannel
                
                print(self.channel)
                
            }
            
            
       //     self.table!.setNumberOfRows(array1.count, withRowType: "tableRowController")
            
      //      var index = 0
            
      //      while index < array1.count {
                
       //         let row = self.table.rowControllerAtIndex(index) as! tableRowController
                
        //        row.rowLabel.setText(array1[index])
                
          //      row.dateLabel.setText(array2[index])
                
       //         index++
                
      //      }
            
        }
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieving message from iphone
        
        self.labelWatch.setText(message["a"]! as? String)
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData) {
        //recieving message from iphone
        
        self.imageWatch.setImage(UIImage(data: messageData))
    }
    
}
