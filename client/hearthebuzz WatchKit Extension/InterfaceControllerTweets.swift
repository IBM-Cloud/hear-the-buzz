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
    
    
    @IBAction func playAudio() {
        self.setTitle("Audio")
    
    }
    
    var sentimentString:String = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var segue = (context as! NSDictionary)["segue"] as? String
        let data = (context as! NSDictionary)["data"] as? String
        
        self.setTitle("Buzz")
        
        sentimentString = data!
    }
    
    override func willActivate() {
        super.willActivate()
        let dictionary = NSDictionary(objects: [sentimentString], forKeys: ["sentiment"])
        
        WKInterfaceController.openParentApplication(dictionary as [NSObject : AnyObject], reply: { (replyInfo, error) -> Void in
            
            let dictionary = replyInfo as NSDictionary
            replyInfo.count
            self.interfaceTable.setNumberOfRows(replyInfo.count / 2 - 1, withRowType: "cell")
            
            for (var i = 0; i < replyInfo.count / 2 - 1; i++) {
                let number = i as NSNumber
                let row: TweetRow = self.interfaceTable.rowControllerAtIndex(i) as! TweetRow
                
                row.titleLabel.setText(dictionary["tweet" + number.stringValue + ".message"] as! String)
                row.authorLabel.setText(dictionary["tweet" + number.stringValue + ".authorName"] as! String)
            }
            
            let topicObject: AnyObject? = replyInfo["topic"]
            if topicObject != nil {
                let dictionary = replyInfo as NSDictionary
                self.selectedTopicLabel.setText(dictionary["topic"] as! String)
            }
        })
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}