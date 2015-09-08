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

#import "audioPlayer.h"
#import <OrigamiEngine/ORGMEngine.h>

@implementation audioPlayer

 ORGMEngine* orgmPlayer;

- (NSURL *)engineExpectsNextUrl:(ORGMEngine *)engine {
    return nil;
}

- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state {
    switch (state) {
        case ORGMEngineStateStopped: {
            break;
        }
        case ORGMEngineStatePaused: {
            break;
        }
        case ORGMEngineStatePlaying: {
          
            break;
        }
        case ORGMEngineStateError:
            break;
    }
}

-(void) playSynthesizedAudio:(NSString*) phrase {
    
    NSString *server = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Backend_Route"];
    NSString *serverAndPath = [NSString stringWithFormat:@"%@/synthesize?text=", server];
    NSString *urlString = [NSString stringWithFormat:@"%@%@&download=1&voice=en-US_LisaVoice&accept=audio/flac", serverAndPath, phrase ];
    
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *oggUrl = [NSURL URLWithString:webStringURL];
    
    IMFLogger *logger;
    logger = [IMFLogger loggerForName:@"hear-the-buzz"];
    [logger logDebugWithMessages:@"Watson REST URL: "];
    [logger logDebugWithMessages:webStringURL];
    
    NSData *audioData = [NSData dataWithContentsOfURL:oggUrl];
    NSString *docDirPath = NSTemporaryDirectory() ;
    NSString *filePath = [NSString stringWithFormat:@"%@transcript.flac", docDirPath ];
    [audioData writeToFile:filePath atomically:YES];
    
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    if (orgmPlayer == nil) {
        orgmPlayer = [[ORGMEngine alloc] init];
        orgmPlayer.delegate = self;
    }
    
    [orgmPlayer playUrl:fileUrl];
}

@end
