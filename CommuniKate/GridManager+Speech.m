//
//  GridManager+Speech.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 17/07/2017.
//   
//

#import "GridManager+Speech.h"


@implementation GridManager (Speech)

#pragma mark - Speech Synthesizer

// Speech Toggle
-(void)speak: (NSString *) text {
    if(![text isEqualToString:@""]){
        if([self.synthesizer isSpeaking]){
            [self.synthesizer stopSpeakingAtBoundary: AVSpeechBoundaryImmediate];
        }else{
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: text];
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
            [self.synthesizer speakUtterance: utterance];
        }
    }
}
@end
