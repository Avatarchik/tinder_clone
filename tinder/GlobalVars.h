//
//  GlobalVars.h
//  tinder
//
//  Created by My Mac on 3/7/16.
//  Copyright © 2016 Johan. All rights reserved.
//

#ifndef GlobalVars_h
#define GlobalVars_h

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{
    NSMutableArray *default_people;
    NSMutableArray *availableChatrooms;
}
+ (GlobalVars *)sharedInstance;
@property(strong, nonatomic, readwrite) NSMutableArray *default_people;
@property(strong, nonatomic, readwrite) NSMutableArray *availableChatrooms;
@end

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#endif /* GlobalVars_h */
