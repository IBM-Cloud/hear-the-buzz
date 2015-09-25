// Copyright 2015 IBM Corp. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import Foundation
import SpriteKit

import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topic: UITextField!
    
    @IBAction func topicChanged(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let newTopic = topic.text
        appDelegate.topic = newTopic!
    }
    
    @IBAction func clearText(sender: AnyObject) {
        topic.text = ""
    }
 
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.topic.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let topicValue = topic.text
        (segue.destinationViewController as! ViewControllerTweets).topic = topicValue
        if segue.identifier == "Positive" {
            (segue.destinationViewController as! ViewControllerTweets).sentiment = "Positive"
        }
        if segue.identifier == "Neutral" {
            (segue.destinationViewController as! ViewControllerTweets).sentiment = "Neutral"
        }
        if segue.identifier == "Negative" {
            (segue.destinationViewController as! ViewControllerTweets).sentiment = "Negative"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



