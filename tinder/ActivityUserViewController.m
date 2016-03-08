//
//  ActivityUserViewController.m
//  tinder
//
//  Created by My Mac on 3/8/16.
//  Copyright © 2016 Johan. All rights reserved.
//

#import "ActivityUserViewController.h"
#import "GlobalVars.h"
#import <Parse/Parse.h>
#import "TinderConstants.h"
#import "ChatViewController.h"

@implementation ActivityUserViewController


- (NSMutableArray *)availableChatrooms {
    if (!_availableChatrooms) {
        _availableChatrooms = [[NSMutableArray alloc] init];
    }
    return _availableChatrooms;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // [self updateAvailableChatRooms];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    personsCollestionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];

    
    [personsCollestionView setDataSource:self];
    [personsCollestionView setDelegate:self];

    [personsCollestionView setBackgroundColor:[UIColor whiteColor]];
    [personsCollestionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    
    [self.view addSubview:personsCollestionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return CGSizeMake (0,0);
    else
        return CGSizeMake (0, 50);
    
    return CGSizeMake(0, 50); // default iPhone6
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:79/255.0f alpha:1.0f];
    
    cell.backgroundColor = [UIColor blackColor];
    
    if (cell) {
//        for (UIView *pView in cell.subviews) {
//            [pView removeFromSuperview];
//        }
    }
    
    GlobalVars *gVars = [GlobalVars sharedInstance];
    if ([gVars.availableChatrooms count] == 0 ) {
        // return cell;
    }
    
    PFObject *chatRoom = [gVars.availableChatrooms objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatRoom[@"user1"];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {  // must compare Parse objects using objectId
        likedUser = [chatRoom objectForKey:@"user2"];
    } else {
        likedUser = [chatRoom objectForKey:@"user1"];
    }
    
    NSString *strName = likedUser[@"profile"][@"name"];
    
    UIImageView *personImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 93, 93)];
    
    
    PFQuery *queryForPhoto = [PFQuery queryWithClassName:@"Photo"];
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kTinderPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                personImgView.image = [self cropImage:[UIImage imageWithData:data]];
            }];
        }
    }];

    UIImageView *circleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    circleImgView.image = [UIImage imageNamed:@"CircleGreen"];
    [cell addSubview:circleImgView];

    personImgView.contentMode = UIViewContentModeScaleAspectFit;
    personImgView.layer.cornerRadius = 47;
    personImgView.clipsToBounds = YES;
    [cell addSubview:personImgView];

    UILabel *personName = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 70, 25)];
    
    personName.text = strName;
    personName.font = [UIFont fontWithName:@"Avenir Next Medium" size:16];
    personName.textColor = [UIColor colorWithRed:122/255.0f green:125/255.0f blue:145/255.0f alpha:1.0f];
    [cell addSubview:personName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{  
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    ChatViewController *chatVC = [[ChatViewController alloc] init] ;
    chatVC.chatRoom = vars.availableChatrooms[indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    GlobalVars *gVars = [GlobalVars sharedInstance];
    
    return [gVars.availableChatrooms count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        return UIEdgeInsetsMake(15, 20, 15, 20);
    }
    else{
        return UIEdgeInsetsMake(20, 5, 20, 5);
    }
    return UIEdgeInsetsMake(20, 5, 20, 5); // default iPhone 6
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.sections.count;
    return 1;
}


#pragma CropImage

-(double) rad:(double) deg
{
    return deg / 180.0 * M_PI;
}

-(UIImage*)cropImage:(UIImage*) img
{
    
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.width);
    
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation([self rad:(90)]), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation([self rad:(-90)]), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation([self rad:(-180)]), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, img.scale, img.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:img.scale orientation:img.imageOrientation];
    CGImageRelease(imageRef);
    
    
    
    return result;
}


-(NSString*) ColorStr:(NSString*)strColor
{
    
    if ([strColor isEqualToString:@"green"]) {
        strColor = @"CircleGreen";
    }
    else if([strColor isEqualToString:@"yellow"])
    {
        strColor = @"CircleYellow";
    }
    else if([strColor isEqualToString:@"pink"])
    {
        strColor = @"CirclePink";
    }
    else if([strColor isEqualToString:@"purple"])
    {
        strColor = @"CirclePurple";
    }
    else if([strColor isEqualToString:@"orange"])
    {
        strColor = @"CircleOrange";
    }
    
    return strColor;
}

- (void) updateAvailableChatRooms {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined includeKey:@"chat"];  //get back the complete Chat class, not just the pointer
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatrooms removeAllObjects];
            self.availableChatrooms = [objects mutableCopy];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end


