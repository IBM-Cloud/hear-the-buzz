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

class ViewModel {
    
    var sentiment:String = "Positive"
    var topic:String = "bluemix"
    
    var tweetsData = [Tweet]()
    
    func fetchTweets(success:() -> ()) {
        let backend_Route = NSBundle.mainBundle().objectForInfoDictionaryKey("Backend_Route") as! String
        var baseUrl = backend_Route + "/api/1/messages/search?q="
        baseUrl = baseUrl.stringByReplacingOccurrencesOfString("https://", withString: "")
        
        topic = topic.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        topic = topic.stringByReplacingOccurrencesOfString(" ", withString: " AND ")
        
        var restUrl = baseUrl + topic + " AND lang:en AND sentiment:"
        if sentiment == "Positive" {
            restUrl = restUrl + "positive AND posted:"
        }
        else
        {
            if sentiment == "Neutral" {
                restUrl = restUrl + "neutral AND posted:"
            }
            else {
                restUrl = restUrl + "negative AND posted:"
            }
        }
        
        let flags: NSCalendarUnit = [.NSDayCalendarUnit, .NSMonthCalendarUnit, .NSYearCalendarUnit]
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        let year:Int = components.year
        let month:Int = components.month
        let day:Int = components.day
        let yearNumber = year as NSNumber
        let monthNumber = month as NSNumber
        let dayNumber = day as NSNumber
        var monthString:String = "";
        var dayString:String = ""
        if month < 10 {
            monthString = "0" + monthNumber.stringValue
        } else {
            monthString = monthNumber.stringValue
        }
        if day < 10 {
            dayString = "0" + dayNumber.stringValue
        } else {
            dayString = dayNumber.stringValue
        }
        restUrl = restUrl + yearNumber.stringValue + "-" + monthString + "-" + dayString;
        let logger = IMFLogger(forName:"hear-the-buzz")
        IMFLogger.setLogLevel(IMFLogLevel.Info)
        logger.logInfoWithMessages("Twitter REST URL: ")
        logger.logInfoWithMessages("http://" + restUrl)
        
        restUrl = restUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        restUrl = restUrl.stringByReplacingOccurrencesOfString(":", withString: "%3A");
        restUrl = "https://" + restUrl
        //println(restUrl)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let url = NSURL(string: restUrl)
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            let parser = JSONParser()
            self.tweetsData = parser.titlesFromJSON(data!)
            
            let logger = IMFLogger(forName:"hear-the-buzz")
            IMFLogger.setLogLevel(IMFLogLevel.Info)
            logger.logInfoWithMessages("Tweets: ")
            for tweet in self.tweetsData {
                logger.logInfoWithMessages(tweet.message)
            }
            success()
        }
        task.resume()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return tweetsData.count
    }
    
    func titleForItemAtIndexPath(indexPath: NSIndexPath) -> String {
        let message:String = tweetsData[indexPath.row].message
        return message
    }
}