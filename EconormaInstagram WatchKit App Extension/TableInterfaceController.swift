//
//  TableInterfaceController.swift
//  MyWatch
//
//  Created by Alessandro Mattiuzzi MacPro on 28/04/16.
//  Copyright © 2016 Alessandro Mattiuzzi MacPro. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class TableInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var tableView: WKInterfaceTable!
    @IBOutlet var tableRow: NSObject!
    @IBOutlet var labelRow: WKInterfaceLabel!
    
    var sensors = [String]()
    var desSensors = [String]()
    var dateStr = [String]()
    var temp = [String]()
    var channel = [String]()
    
    var session:WCSession!
   
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
        
    }
    
//    func reloadData(){
//        self.tableView.removeRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, 100)))
//    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
   
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        showPopup("azz")
        
    }
    
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        
//         dispatch_async(dispatch_get_main_queue()) { () -> Void in
//        
//            if let retrievedSensors = applicationContext["sensor"] as? [String] {
//                
//               
//                self.sensors = retrievedSensors
//                
//                print(self.sensors)
//                
//            }
//            
//            if let retrievedDescription = applicationContext["description"] as? [String] {
//                
//                self.desSensors = retrievedDescription
//                
//                print(self.desSensors)
//                
//            }
//            
//            if let retrievedDate = applicationContext["date"] as? [String] {
//                
//                self.dateStr = retrievedDate
//                
//                print(self.dateStr)
//                
//            }
//            
//            if let retrievedTemp = applicationContext["temp"] as? [String] {
//                
//                self.temp = retrievedTemp
//                
//                print(self.temp)
//                
//            }
//            
//            if let retrievedChannel = applicationContext["channel"] as? [String] {
//                
//                self.channel = retrievedChannel
//                
//                print(self.channel)
//                
//            }
//            
//            
//             self.tableView.setNumberOfRows(self.sensors.count, withRowType: "DetailRow")
//            
//            for i in 0 ..< self.sensors.count {
//                if let row = self.tableView.rowControllerAtIndex(i) as? DetailRow {
//                    row.labelInfo.setText(self.sensors[i] + " " + self.desSensors[i] + " " + self.dateStr[i] + " " + self.temp[i])
//                }
//            }
//        }
//        
//    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        let message : String = applicationContext["message"] as! String
        showPopup(message)
    }
    

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieving message from iphone
        
        let watchMessagge = message["a"]! as? String
        
        showPopup(watchMessagge!)
        
        
    }
    
    func showPopup(messagge: String){
        
        let h0 = { print("ok")}
        
        let action1 = WKAlertAction(title: "Approve", style: .Default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .Destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .Cancel) {}
        
        presentAlertControllerWithTitle("Voila", message: messagge, preferredStyle: .ActionSheet, actions: [action1, action2, action3])
        
        
    }
    
}
