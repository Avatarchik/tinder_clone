//
//  GlobalVars.m
//  tinder
//
//  Created by My Mac on 3/7/16.
//  Copyright © 2016 Johan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVars.h"

@implementation GlobalVars

@synthesize default_people;
@synthesize availableChatrooms;

+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        default_people = [[NSMutableArray alloc] init];
        availableChatrooms = [[NSMutableArray alloc] init];
    }
    return self;
}

@end