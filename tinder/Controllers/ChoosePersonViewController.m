//
// ChoosePersonViewController.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChoosePersonViewController.h"
#import "Person.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "OnboardingViewController.h"

#import <Parse/Parse.h>
#import "TinderConstants.h"
#import "GlobalVars.h"

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 30.f;

@interface ChoosePersonViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) UIImage* peopleImg;

@property (strong, nonatomic) NSArray *photos;  // store all photos we get back from Parse
@property (strong, nonatomic) PFObject *photo;  // current photo on screen
@property (strong, nonatomic) NSMutableArray *activities; // keep track of activities

@property (nonatomic) int currentPhotoIndex;    // keep track of current photo in the photos array
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;
@end

@implementation ChoosePersonViewController

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        GlobalVars *gVars = [GlobalVars sharedInstance];
        _people = [gVars.default_people mutableCopy];
        
        // _people = [[self defaultPeople] mutableCopy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"CHoosePersonViewController Loaded");
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];

    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];

    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kTinderPhotoClassKey];
    [query whereKey:kTinderPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kTinderPhotoUserKey];  // include the actual User object when we retrieve a photo
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
                [self queryForCurrentPhotoIndex];
//            if ([self allowPhoto] == NO) {
//                [self setupNextPhoto];
//            } else {
//                [self queryForCurrentPhotoIndex];
//            }
        } else {
            NSLog(@"Error:%@", error);
        }
    }];

}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        if (self.currentPhotoIndex + 1 < [self.photos count]) {
            self.currentPhotoIndex++;
            [self queryForCurrentPhotoIndex];
            
            [self saveDislike];
        }
    } else {
        if (self.currentPhotoIndex + 1 < [self.photos count]) {
            self.currentPhotoIndex++;
            [self queryForCurrentPhotoIndex];
            
            [self saveLike];
        }
    }

    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    
    if ([self.people count] == 0) {
        if (self.frontCardView == nil) {
            [self.view setHidden:YES];
            [self.view.superview setHidden:YES];
        }
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    [self.people removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"unlike"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ChoosePersonButtonHorizontalPadding,
                                                                 CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                                                                 image.size.width,
                                                                 image.size.height)];

    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIImage *image = [UIImage imageNamed:@"like"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                                                                 CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                                                                 image.size.width,
                                                                  image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    if (self.currentPhotoIndex + 1 < [self.photos count]) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
        
        [self saveDislike];
    }

    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    if (self.currentPhotoIndex + 1 < [self.photos count]) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
        
        [self saveDislike];
    }

    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}


- (void)saveLike {
    PFObject *likeActivity = [PFObject objectWithClassName:kTinderActivityClassKey];
    [likeActivity setObject:kTinderActivityTypeLikeKey forKey:kTinderActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kTinderActivityFromUserKey];
    [likeActivity setObject:self.photo[kTinderPhotoUserKey] forKey:kTinderActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kTinderActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self checkForPhotoUserLikes];  // possibly create chatroom if there is mutual like
      //   [self setupNextPhoto];
    }];
}

- (void)checkForPhotoUserLikes {
    PFQuery *query = [PFQuery queryWithClassName:kTinderActivityClassKey];
    // this user we are viewing as in fact liked me
    [query whereKey:kTinderActivityFromUserKey equalTo:self.photo[kTinderPhotoUserKey]];
    [query whereKey:kTinderActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kTinderActivityTypeKey equalTo:kTinderActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            // create our chat room
            [self createChatRoom];
        }
    }];
}

- (void)createChatRoom {
    
    // current user could be user 1 or user 2 so we have to check both scenarios
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:kTinderChatRoomClassKey];
    [queryForChatRoom whereKey:kTinderChatRoomUser1Key equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:kTinderChatRoomUser2Key equalTo:self.photo[kTinderPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:kTinderChatRoomClassKey];
    [queryForChatRoomInverse whereKey:kTinderChatRoomUser1Key equalTo:self.photo[kTinderPhotoUserKey]];
    [queryForChatRoomInverse whereKey:kTinderChatRoomUser2Key equalTo:[PFUser currentUser]];
    
    // combine the 2 queries
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            // there is no existing chatroom, so start a new one
            PFObject *chatRoom = [ PFObject objectWithClassName:kTinderChatRoomClassKey];
            [chatRoom setObject:[PFUser currentUser] forKey:kTinderChatRoomUser1Key];
            [chatRoom setObject:self.photo[kTinderPhotoUserKey] forKey:kTinderChatRoomUser2Key];
            [chatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               //  [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
                
                NSLog(@"Match Successed!");
            }];
            
        }
    }];
}

- (void)saveDislike {
    PFObject *dislikeActivity = [PFObject objectWithClassName:kTinderActivityClassKey];
    [dislikeActivity setObject:kTinderActivityTypeDislikeKey forKey:kTinderActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kTinderActivityFromUserKey];
    [dislikeActivity setObject:self.photo[kTinderPhotoUserKey] forKey:kTinderActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kTinderActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:dislikeActivity];
       //  [self setupNextPhoto];
    }];
}

- (void)queryForCurrentPhotoIndex {
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kTinderPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
               //  UIImage *image = [UIImage imageWithData:data];
                //self.photoImageView.image = image;
                //[self updateView];
                
                // [self setupBackgroundViews];
                
            } else NSLog(@"Failed to download photo:%@", error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kTinderActivityClassKey];
        [queryForLike whereKey:kTinderActivityTypeKey equalTo:kTinderActivityTypeLikeKey];
        [queryForLike whereKey:kTinderActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kTinderActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kTinderActivityClassKey];
        [queryForDislike whereKey:kTinderActivityTypeKey equalTo:kTinderActivityTypeDislikeKey];
        [queryForDislike whereKey:kTinderActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kTinderActivityFromUserKey equalTo:[PFUser currentUser]];
        
        // Join the 2 queries
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                } else {
                    // does in fact have either a like or dislike
                    PFObject *activity = self.activities[0];
                    if ([activity[kTinderActivityTypeKey] isEqualToString:kTinderActivityTypeLikeKey]) {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    } else if ([activity[kTinderActivityTypeKey] isEqualToString:kTinderActivityTypeDislikeKey]) {
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    } else {
                        // some sort of other activity
                    }
                    
                }
//                self.likeButton.enabled = YES;
//                self.dislikeButton.enabled = YES;
//                self.infoButton.enabled = YES;
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

@end
