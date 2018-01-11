//
//  GridManager+Speech.m
//  CommuniKate
//
//  Created by Kalpesh Modha on 17/07/2017.
//   
//

#import "GridManager+Speech.h"

NSString *const kVoiceLanguageKey = @"kVoiceLanguageKey";
NSString *const kDefaultVoiceLanguage = @"en-GB";

@implementation GridManager (Speech)

#pragma mark - Speech Synthesizer

- (NSString *)voiceLanguage {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:kVoiceLanguageKey];
    return savedLanguage ? savedLanguage : kDefaultVoiceLanguage;
}

- (void)setVoiceLanguage:(NSString *)voiceLanguage {
    [[NSUserDefaults standardUserDefaults] setObject:voiceLanguage forKey:kVoiceLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Speech Toggle
- (void)speak:(NSString *)text {
    if (![text isEqualToString:@""]) {
        if ([self.synthesizer isSpeaking]) {
            [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        } else {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.voiceLanguage];
            [self.synthesizer speakUtterance:utterance];
        }
    }
}

- (void)changeVoiceLanguage:(NSString *)language {
    self.voiceLanguage = language;
}

@end
