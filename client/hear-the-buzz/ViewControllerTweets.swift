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

import Foundation

class ViewControllerTweets: UITableViewController {
    
    let audio = audioPlayer();
    
    @IBAction func play(sender: AnyObject) {
        var text : NSString
        text = ""
        
        let tweets = self.viewModel.tweetsData
        let tweet:Tweet
        let maxNumber = 5
        var number = 0
        for tweet in tweets {
            number = number + 1
            if (number <= maxNumber) {
                text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                var message = tweet.message
            
                message = message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                message = message.stringByReplacingOccurrencesOfString("#", withString: "")
                message = message.stringByReplacingOccurrencesOfString("\n", withString: "")
                message = message.stringByReplacingOccurrencesOfString("-", withString: "")
                message = message.stringByReplacingOccurrencesOfString("1)", withString: "")
                message = message.stringByReplacingOccurrencesOfString("2)", withString: "")
                message = message.stringByReplacingOccurrencesOfString("3)", withString: "")
                message = message.stringByReplacingOccurrencesOfString(")", withString: "")
                message = message.stringByReplacingOccurrencesOfString("&amp;", withString: " ")
                message = message.stringByReplacingOccurrencesOfString("...", withString: ".")
                message = message.stringByReplacingOccurrencesOfString("..", withString: ".")
                message = message.stringByReplacingOccurrencesOfString("dashDB", withString: "dash DB")
                if message.hasPrefix(".@") {
                    message = message.stringByReplacingOccurrencesOfString(".@", withString: "Addressed to Twitter user ")
                }
                message = message.stringByReplacingOccurrencesOfString("@", withString: "Twitter user ")
                if message.lowercaseString.rangeOfString("http") != nil {
                    let index = message.rangeOfString("http")?.startIndex
                    message = message.substringToIndex(index!)
                }
                if message.hasPrefix("RT") {
                    if message.rangeOfString(":") != nil {
                        let index = message.rangeOfString(":")?.startIndex
                        message = message.substringFromIndex(index!)
                    }
                    message = message.stringByReplacingOccurrencesOfString(":", withString: "")
                    message = message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
               
                    text = (text as String)  + " " + tweet.authorName + " retweeted. " + message as String + ". <break time='2s'/>"
                }
                else {
                    message = message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    text = (text as String) + " " + tweet.authorName + " tweeted. " + message as String + ". <break time='2s'/>"
                }
            } 
        }
               
        let logger = IMFLogger(forName:"hear-the-buzz")
        IMFLogger.setLogLevel(IMFLogLevel.Info)
        logger.logInfoWithMessages("Text to be sent to Watson: ")
        logger.logInfoWithMessages(text as String)
        
        audio.playSynthesizedAudio(text as String)
    }
    
    @IBOutlet weak var myActivityIndiator: UIActivityIndicatorView!
    
    @IBOutlet var myTableView: UITableView!
        func setupTweets() {
        
        viewModel.fetchTweets {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    var topic:String?
    var sentiment:String?
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        if let topicString = topic {
            if let sentiment2 = sentiment {
                self.title = sentiment2 + ": " + topicString
                
            }
        }
    }
    
    func refresh() {
        if let topicString = topic {
            if let sentiment2 = sentiment {
                viewModel.sentiment = sentiment2
                viewModel.topic = topicString
            }
        }
        
        //myActivityIndiator.startAnimating()
            
        viewModel.fetchTweets {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
                self.refreshControl?.endRefreshing()
                
                self.myActivityIndiator.stopAnimating()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TweetCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetCellTableViewCell
        
        let tweet = self.viewModel.tweetsData[indexPath.row]
        
        cell.label.text = tweet.authorName
        cell.textArea.text = tweet.message
        cell.textArea.textColor = UIColor.whiteColor()
        cell.textArea.font = UIFont(name: "System", size: 24.0)
        cell.loadImage(tweet.authorPictureUrl)
        
        return cell
        
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel!.text = self.viewModel.titleForItemAtIndexPath(indexPath)
    }
}