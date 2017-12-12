//
//  CommuniKateTests.h
//  CommuniKate
//
//  Created by Kalpesh Modha on 21/07/2017.
//   
//

#ifndef CommuniKateTests_h
#define CommuniKateTests_h

static inline void runTestInMainLoop(void(^ _Nullable block)(BOOL * _Nullable done)) {
    __block BOOL done = NO;
    block(&done);
    while (!done) {
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

extern NSString *const _Nonnull testPath;

#endif /* CommuniKateTests_h */
