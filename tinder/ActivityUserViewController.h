//
//  ActivityUserViewController.h
//  tinder
//
//  Created by My Mac on 3/8/16.
//  Copyright © 2016 Johan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityUserViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *personsCollestionView; 
}

@property (strong, nonatomic) NSMutableArray *availableChatrooms;

@end
