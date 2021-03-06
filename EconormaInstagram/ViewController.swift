//
//  CatsTableViewController.swift
//  Paws
//
//  Created by Simon Ng on 15/4/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, WCSessionDelegate {
    
    var customView:CustomView!
    var activityIndicator:UIActivityIndicatorView!
    var refresh: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var firebase = Firebase()
    var uuid: String = ""
    var items = [Image]()
    var cameraBool = false
    
    var sensors = [String]()
    var desSensors = [String]()
    var dateStr = [String]()
    var temp = [String]()
    var channel = [String]()
    
    var session: WCSession!
    
    override func viewDidLoad() {
        navigationController!.navigationBar.barStyle = .Black
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tableView.delegate = self
        tableView.dataSource = self
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(ImagesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresh)
        uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        firebase = Firebase(url:"https://econormainstagram.firebaseio.com/images")
        loadDataFromFirebase()
        super.viewDidLoad()
        
        loadArray()
        
        if(WCSession.isSupported()){
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func loadDataFromFirebase() {
        
        addActivityIndicator()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Image]()
            
            for item in snapshot.children {
                let receipt = Image(snapshot: item as! FDataSnapshot)
                newItems.append(receipt)
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.removeActivityIndicator()
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //         return items.count
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
      
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "imageCell"
        
        var cell: ImagesTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? ImagesTableViewCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ImagesTableViewCell
        }
        
        let imageItem = items[indexPath.row]
        let imageData = NSData(base64EncodedString: imageItem.photo, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        cell.catImageView?.image = image
        cell.catNameLabel?.text = "Ciccio Pasticcio"
        cell.dateLabel.text = imageItem.date
        cell.dateLabel?.font = UIFont.boldSystemFontOfSize(14)
        cell.dateLabel?.textColor = UIColor.rgb(155, green: 161, blue: 171)
        cell.catNameLabel?.font = UIFont.boldSystemFontOfSize(14)
//        cell.catNameLabel?.textColor = UIColor.rgb(155, green: 161, blue: 171)
        
        
        return cell
        
        
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! ImagesTableViewCell
        //        let imageItem = items[indexPath.row]
        //
        //        let imageData = NSData(base64EncodedString: imageItem.photo, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        //        let image = UIImage(data: imageData!)
        //        cell.catImageView?.image = image
        //
        //        cell.catNameLabel?.text = "Ciccio Pasticcio"
        //
        //
        //        cell.detailTextLabel?.text = imageItem.author + "  (" + imageItem.date + ")"
        //
        //
        //        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    @IBAction func addAction(sender: AnyObject) {
        
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .ActionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .Default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .Camera
                                                self.presentViewController(imagePicker,
                                                                           animated: true,
                                                                           completion: nil)
                                                self.cameraBool = true
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .Default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .PhotoLibrary
                                            self.presentViewController(imagePicker,
                                                                       animated: true,
                                                                       completion: nil)
                                            self.cameraBool = false
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        presentViewController(imagePickerActionSheet, animated: true,
                              completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        //        if (cameraBool) {
        //            UIImageWriteToSavedPhotosAlbum(image, self, #selector(ImagesTableViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        //        }
        
        
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        
        
        
        dismissViewControllerAnimated(true, completion: {
            //            self.addActivityIndicator()
            self.storeData(selectedImage)
            self.loadDataFromFirebase()
        })
    }
    
    
    
    func storeData(selectedImage: UIImage){
        
        uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        firebase = Firebase(url:"https://econormainstagram.firebaseio.com/images")
        
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(selectedImage,0.1)!
        
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        
        let image: NSDictionary = ["uuid":uuid, "name": "Me", "label": "foto", "author":"Ciccio Pasticcio", "date":convertedDate, "comment": "", "photo": base64String]
        
        let profile = firebase.ref.childByAutoId()
        
        // Write data to Firebase
        profile.setValue(image)
        
        //        let alertController = UIAlertController(title: "Info", message: "Save correct", preferredStyle: UIAlertControllerStyle.Alert)
        //        presentViewController(alertController, animated: true, completion: nil)
        //
        //        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
        //            self.navigationController?.popViewControllerAnimated(true)
        //            return;
        //        }))
        
        
        
    }
   
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        if let indicator = activityIndicator {
            activityIndicator.removeFromSuperview()
            activityIndicator = nil
            
        }
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
            return
        })
    }
    
    
    
    
    func refresh(sender:AnyObject)
    {
        self.do_table_refresh()
    }
    
    
    @IBAction func plusAction(sender: AnyObject) {
        
        customView = CustomView.loadNib()
        customView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        customView.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        customView.layer.borderWidth = 1.0
        customView.layer.cornerRadius = 1
        let catImage = UIImage(named: "cat.jpeg")
        customView.imageView.image = catImage
        customView.commentTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        customView.commentTextField.layer.borderWidth = 1.0
        customView.commentTextField.layer.cornerRadius = 1
        customView.commentTextField.delegate=self
        customView.confirmButton.layer.cornerRadius = 5
        customView.confirmButton.layer.borderWidth = 1
        customView.confirmButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        customView.confirmButton.addTarget(self, action: #selector(ViewController.confirmButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        customView.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)
        
        customView.alpha = 0.0
        self.view.addSubview(customView)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.customView.alpha = 1.0
        }
        
        
        
//         UIView.transitionFromView(self.view, toView: self.customView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        
    }
    
    func confirmButtonTapped(sender:UIButton)
    {
        customView.removeFromSuperview()
    }
    
    
    
    func loadArray(){
        
        sensors.append("SONDA1")
        sensors.append("SONDA2")
        sensors.append("SONDA3")
        sensors.append("SONDA4")
        
        desSensors.append("CELLA FRIGO 1")
        desSensors.append("CELLA FRIGO 2")
        desSensors.append("CELLA FRIGO 3")
        desSensors.append("CELLA FRIGO 4")
        
        dateStr.append("21/01/2016 20:15:23")
        dateStr.append("21/01/2016 20:22:23")
        dateStr.append("21/01/2016 20:11:23")
        dateStr.append("21/01/2016 20:15:23")
        
        temp.append("-2.7")
        temp.append("-12.7")
        temp.append("10")
        temp.append("15.7")
        
        channel.append("ft2500")
        channel.append("ft2500")
        channel.append("ft2500")
        channel.append("ft2500")
        
    }
    
    
    @IBAction func backgroundAppleWatch(sender: AnyObject) {
       
            do {
                try session?.updateApplicationContext(
                    ["message" : "what the fuck"]
                )
            } catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
            }
         
        
        
//        do {
//           let applicationDict = ["sensor": sensors, "description": desSensors, "date": dateStr, "temp": temp, "channel": channel]
//                try WCSession.defaultSession().updateApplicationContext(applicationDict)
//        } catch {
//            let alert = UIAlertController(title: "Errore", message: "ASsssssss", preferredStyle: UIAlertControllerStyle.Alert)
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
        
    }
    
    @IBAction func playAppleWatch(sender: AnyObject) {
         session.sendMessage(["a":"hello"], replyHandler: nil, errorHandler: nil)
        
//        let image = UIImage(named: "cat.jpeg")
//        let data = UIImageJPEGRepresentation(image!, 1.0)
        
//        let imageItem = items[0]
//        let imageData = NSData(base64EncodedString: imageItem.photo, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//        let image = UIImage(data: imageData!)
//        let data = UIImageJPEGRepresentation(image!, 1.0)
 
        
//        session.sendMessageData(data!, replyHandler: nil, errorHandler: nil)
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let watchMessagge = message["b"]! as? String
            let alert = UIAlertController(title: "Apple Watch Reply", message: watchMessagge, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                (alertAction: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
        })
    }
}
