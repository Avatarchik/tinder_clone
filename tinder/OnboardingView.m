//
//  OnboardingView.m
//  tinder
//
//  Created by Ren He on 2016-02-13.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import "OnboardingView.h"
#import "UIView+Extensions.h"
#import "TinderConstants.pch"

@implementation OnboardingView

- (id)initWithFrame:(CGRect)frame body:(NSString *)body plusOffset:(CGFloat)offset intro:(NSString *)intro {
    self = [super init];
    
    if (self) {
        
        UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320)/2.0f, 30, 320, 100)];
        bodyLabel.numberOfLines = -1;
        bodyLabel.textAlignment = NSTextAlignmentCenter;
        bodyLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
        [bodyLabel setFont:[UIFont fontWithName:@"PTSerif-Regular" size:30]];
        bodyLabel.text = body;
        [self addSubview:bodyLabel];
        
        CGRect bodyframe = bodyLabel.frame;
        bodyLabel.frame = CGRectMake(bodyframe.origin.x + offset, 30, 320, 44);
        
        UIImageView *iphoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:intro]];
        iphoneImage.center = CGPointMake(frame.size.width / 2 + offset, frame.size.height / 1.95);
        [self addSubview:iphoneImage];
    }
    return self;
}

@end
