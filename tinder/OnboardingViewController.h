//
//  OnboardingViewController.m
//  tinder
//
//  Created by Ren He on 2016-02-13.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OnboardingViewController : UIViewController <NSURLConnectionDataDelegate>
-(void)reloadViews;
-(UIView*)matchView:(BOOL)isKey;
- (void)notificationCall;
@end
