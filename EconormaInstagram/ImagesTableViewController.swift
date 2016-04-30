//
//  CatsTableViewController.swift
//  Paws
//
//  Created by Simon Ng on 15/4/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Firebase

class ImagesTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imagesTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var activityIndicator:UIActivityIndicatorView!
    var refresh: UIRefreshControl!
    
    var firebase = Firebase()
    var uuid: String = ""
    var items = [Image]()
    var cameraBool = false
    
    override func viewDidLoad() {
         imagesTableView.delegate = self
        imagesTableView.dataSource = self
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(ImagesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        imagesTableView.addSubview(refresh)
        uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        firebase = Firebase(url:"https://econormainstagram.firebaseio.com/images")
        loadDataFromFirebase()
        super.viewDidLoad()
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
            self.imagesTableView.reloadData()
            
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
        cell.catNameLabel?.text = "Mattiuzzi Alessandro"
        cell.catNameLabel?.font = UIFont.boldSystemFontOfSize(14)
        cell.catNameLabel?.textColor = UIColor.rgb(155, green: 161, blue: 171)
        
        
        return cell
        
        
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! ImagesTableViewCell
        //        let imageItem = items[indexPath.row]
        //
        //        let imageData = NSData(base64EncodedString: imageItem.photo, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        //        let image = UIImage(data: imageData!)
        //        cell.catImageView?.image = image
        //
        //        cell.catNameLabel?.text = "Mattiuzzi Alessandro"
        //
        //
        //        cell.detailTextLabel?.text = imageItem.author + "  (" + imageItem.date + ")"
        //
        //
        //        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        
        let image: NSDictionary = ["uuid":uuid, "name": "Me", "label": "foto", "author":"Alessandro Mattiuzzi", "date":convertedDate, "comment": "", "photo": base64String]
        
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
            self.imagesTableView.reloadData()
            self.refresh.endRefreshing()
            return
        })
    }
    
    
    
    
    func refresh(sender:AnyObject)
    {
        self.do_table_refresh()
    }
    
    
}
