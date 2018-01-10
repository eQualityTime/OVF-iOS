//
//  GridManager+Speech.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 17/07/2017.
//   
//

#import "GridManager.h"


@interface GridManager (Speech)

@property (strong, nonatomic) NSString *_Nullable voiceLanguage;

// Tests in use observable
- (void)speak:(NSString * _Nonnull)text;
- (void)changeVoiceLanguage:(NSString *_Nonnull)language;
@end
