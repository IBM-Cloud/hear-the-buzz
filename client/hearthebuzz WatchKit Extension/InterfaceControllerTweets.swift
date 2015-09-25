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

import WatchKit
import Foundation

class InterfaceControllerTweets: WKInterfaceController {

    @IBOutlet weak var topicLabel: WKInterfaceLabel!
    @IBOutlet weak var selectedTopicLabel: WKInterfaceLabel!
    @IBOutlet weak var interfaceTable: WKInterfaceTable!
    
    var sentimentString:String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var segue = (context as! NSDictionary)["segue"] as? String
<<<<<<< HEAD
        let data = (context as! NSDictionary)["data"] as? String
=======
        var data = (context as! NSDictionary)["data"] as? String
>>>>>>> origin/master
        
        self.setTitle("Buzz")
        
        sentimentString = data!
    }

    override func willActivate() {
        super.willActivate()
<<<<<<< HEAD
            let dictionary = NSDictionary(objects: [sentimentString], forKeys: ["sentiment"])
            
            WKInterfaceController.openParentApplication(dictionary as [NSObject : AnyObject], reply: { (replyInfo, error) -> Void in
                
                let dictionary = replyInfo as NSDictionary
=======
            var dictionary = NSDictionary(objects: [sentimentString], forKeys: ["sentiment"])
            
            WKInterfaceController.openParentApplication(dictionary as [NSObject : AnyObject], reply: { (replyInfo, error) -> Void in
                
                var dictionary = replyInfo as NSDictionary
>>>>>>> origin/master
                replyInfo.count
                self.interfaceTable.setNumberOfRows(replyInfo.count / 2 - 1, withRowType: "cell")
                
                for (var i = 0; i < replyInfo.count / 2 - 1; i++) {
                    let number = i as NSNumber
<<<<<<< HEAD
                    let row: TweetRow = self.interfaceTable.rowControllerAtIndex(i) as! TweetRow
=======
                    var row: TweetRow = self.interfaceTable.rowControllerAtIndex(i) as! TweetRow
>>>>>>> origin/master
                    
                    row.titleLabel.setText(dictionary["tweet" + number.stringValue + ".message"] as! String)
                    row.authorLabel.setText(dictionary["tweet" + number.stringValue + ".authorName"] as! String)
                }
                
<<<<<<< HEAD
                let topicObject: AnyObject? = replyInfo["topic"]
                if topicObject != nil {
                    let dictionary = replyInfo as NSDictionary
=======
                var topicObject: AnyObject? = replyInfo["topic"]
                if topicObject != nil {
                    var dictionary = replyInfo as NSDictionary
>>>>>>> origin/master
                    self.selectedTopicLabel.setText(dictionary["topic"] as! String)
                }
            })
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}
