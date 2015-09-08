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

class JSONParser {
    func titlesFromJSON(data: NSData) -> [Tweet] {
        var titles = [String]()
        var tweetsData = [Tweet]()
        var jsonError: NSError?
        
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? [String: AnyObject],
            tweets = json["tweets"] as? [[String: AnyObject]] {
            for tweet in tweets {
                if let message = tweet["message"] as? [String: AnyObject],
                    body = message["body"] as? String {
                        
                        titles.append(body)
                        var tweetData:Tweet = Tweet();
                        tweetData.message = body
                        tweetData.message = tweetData.message.stringByReplacingOccurrencesOfString("\n", withString: "")
                        
                        if let link = message["link"] as? String {
                            tweetData.link = link
                        }
                        
                        if let actor = message["actor"] as? [String: AnyObject],
                            displayName = actor["displayName"] as? String {
                                tweetData.authorName = displayName
                                
                                if var image = actor["image"] as? String {
                                    image = image.stringByReplacingOccurrencesOfString("_normal", withString: "")
                                    tweetData.authorPictureUrl = image
                                }
                        }
                        tweetsData.append(tweetData)
                }
            }
        } else {
            if let jsonError = jsonError {
                let logger = IMFLogger(forName:"hear-the-buzz")
                IMFLogger.setLogLevel(IMFLogLevel.Info)
                logger.logInfoWithMessages("Error when parsing JSON from Twitter: \(jsonError)")
            }
        }
        
        return tweetsData
    }
}