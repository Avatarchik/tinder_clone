//
//  YIChatViewController.h
//  MatchMe
//
//  Created by Yi Wang on 8/29/14.
//  Copyright (c) 2014 Yi. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "TinderConstants.h"
#import <Parse/Parse.h>

@interface ChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) PFObject *chatRoom;  //passed in via segue from matches view controller

@end
