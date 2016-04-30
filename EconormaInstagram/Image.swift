/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import Firebase

struct Image {
  
  let key: String!
  let name: String!
  let label: String!
  let author: String!
  let date: String!
  let comment: String!
  let photo: String!
  let uuid: String!
 
  let ref: Firebase?
   
  // Initialize from arbitrary data
    init(name: String, label: String, author: String, date: String, category: String,  comment: String, photo: String,  uuid: String, key: String = "") {
    self.key = key
    self.name = name
    self.label = label
    self.author = author
    self.date = date
    self.comment = comment
    self.photo = photo
    self.uuid = uuid
    self.ref = nil
  }
  
  init(snapshot: FDataSnapshot) {
    key = snapshot.key
    name = snapshot.value["name"] as! String
    label = snapshot.value["label"] as! String
    author = snapshot.value["author"] as! String
    date = snapshot.value["date"] as! String
    comment = snapshot.value["comment"] as! String
    photo = snapshot.value["photo"] as! String
    uuid = snapshot.value["uuid"] as! String
    ref = snapshot.ref
  }
  
 
  
}