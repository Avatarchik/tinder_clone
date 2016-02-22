//
//  OnboardingViewController.m
//  tinder
//
//  Created by Ren He on 2016-02-13.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import "OnboardingViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>

#import "UIView+Extensions.h"
#import "OnboardingView.h"
#import "MainViewController.h"

#import "AppDelegate.h"

#import <SLPagingView/SLPagingViewController.h>
#import "RoundedImageView.h"
#import "UIColor+SLAddition.h"

@interface OnboardingViewController () <UIScrollViewDelegate>
@property (nonatomic) UIButton *fbLogin;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) UIView* mainView;
@property (nonatomic) UIView* bottomView;
@property (nonatomic) UILabel *policyLabel;
@property (nonatomic) UIButton *privacyButton;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIButton *infoButton;

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"OnboardingViewController loaded");
    [self setUpBackground];
    [self addButtons];
    [self setUpScrollView];
    [self addPageControl];
    
    [self initialAnimation];
}

- (void)initialAnimation {

    [UIView animateWithDuration:0.5 animations:^{
        
        self.privacyButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.14+self.privacyButton.frame.size.height/2);
    } completion:nil];
    
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fbLogin.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.15+self.fbLogin.frame.size.height/2+20);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fbLogin.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.15+self.fbLogin.frame.size.height/2);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.policyLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.35+self.policyLabel.frame.size.height/2+15);
        
        self.pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.35+self.pageControl.frame.size.height/2+15);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.policyLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.35+self.policyLabel.frame.size.height/2);
        
        self.pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1/1.35+self.pageControl.frame.size.height/2);
    } completion:nil];
    
    
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2.3+20);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2.3);
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}

- (void)setUpBackground {
    
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor whiteColor];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height*2)];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.mainView addSubview:background];
    [self.mainView addSubview:self.bottomView];
    [self.view addSubview:self.mainView];
    
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.2, self.view.frame.size.height * 1/1.35, 60, 60)];

    self.closeButton.alpha = 0;
    
    [self.closeButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.closeButton];
    
    UIView *spline = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - self.view.frame.size.width/1.2)/2, self.view.frame.size.height,  self.view.frame.size.width/1.2, 1)];
    
    spline.backgroundColor = [UIColor blackColor];
    [self.bottomView addSubview:spline];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 30)];
    topLabel.numberOfLines = -1;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [topLabel setFont:[UIFont systemFontOfSize:20]];
    
    topLabel.text = @"We take your privacy seriously";
    
    [self.bottomView addSubview:topLabel];
    
    
    UILabel *firstsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.center.x/1.5, self.view.frame.size.height + 60, self.view.frame.size.width, 60)];
    firstsLabel.numberOfLines = 2;
    firstsLabel.textAlignment = NSTextAlignmentLeft;
    firstsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [firstsLabel setFont:[UIFont systemFontOfSize:14]];
    
    firstsLabel.text = @"We don't post anything to \nFacebook";
    
    [self.bottomView addSubview:firstsLabel];

    UILabel *secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.center.x/1.5, self.view.frame.size.height + 100, self.view.frame.size.width, 100)];
    secondsLabel.numberOfLines = 3;
    secondsLabel.textAlignment = NSTextAlignmentLeft;
    secondsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [secondsLabel setFont:[UIFont systemFontOfSize:14]];
    
    secondsLabel.text = @"Other users will never know if \nyou've liked them unless they like \nyou back";
    
    [self.bottomView addSubview:secondsLabel];

    UILabel *thirdsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.center.x/1.5, self.view.frame.size.height + 170, self.view.frame.size.width, 100)];
    thirdsLabel.numberOfLines = 3;
    thirdsLabel.textAlignment = NSTextAlignmentLeft;
    thirdsLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [thirdsLabel setFont:[UIFont systemFontOfSize:14]];
    
    thirdsLabel.text = @"Other users cannot contact you \nunless you've already been \nmatched";
    
    [self.bottomView addSubview:thirdsLabel];
    
    UILabel *foursLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.center.x/1.5, self.view.frame.size.height + 240, self.view.frame.size.width, 100)];
    foursLabel.numberOfLines = 2;
    foursLabel.textAlignment = NSTextAlignmentLeft;
    foursLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [foursLabel setFont:[UIFont systemFontOfSize:14]];
    
    foursLabel.text = @"Your location is not shown to other \nusers";
    
    [self.bottomView addSubview:foursLabel];


}

- (void)setUpScrollView {
    int numberOfPages = 3;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.fbLogin.frame.size.height*2)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(numberOfPages * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.mainView addSubview:self.scrollView];
    CGRect viewSize = self.scrollView.bounds;
    
    OnboardingView *firstPage = [[OnboardingView alloc] initWithFrame:viewSize body:@"Anonymously 'Like' or 'Pass' on \n people Tinder Suggests." plusOffset:0 intro:@"Introa"];
    
    [self.scrollView addSubview:firstPage];
    
    //create offset to add subsequent pages
    viewSize = CGRectOffset(viewSize, self.scrollView.bounds.size.width, 0);
    
    //now use new viewSize for second page
    OnboardingView *secondPage = [[OnboardingView alloc] initWithFrame:viewSize body:@"If someone you've liked happens \n to like you back..." plusOffset:self.view.frame.size.width intro:@"Introb"];
    [self.scrollView addSubview:secondPage];
    
    //third page
    viewSize = CGRectOffset(viewSize, self.scrollView.bounds.size.width, 0);
    
    //now use new viewSize for third page
    OnboardingView *thirdPage = [[OnboardingView alloc] initWithFrame:viewSize body:@"Chat with your matches inside \n the app." plusOffset:self.view.frame.size.width * 2 intro:@"Introc"];
    [self.scrollView addSubview:thirdPage];
    
}

- (void)addButtons {
    
    self.policyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.policyLabel.numberOfLines = -1;
    self.policyLabel.textAlignment = NSTextAlignmentCenter;
    self.policyLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    [self.policyLabel setFont:[UIFont systemFontOfSize:10]];
    
    self.policyLabel.text = @"By continuing, you agree to our Terms of \n Service and Privacy Policy";
    [self.mainView addSubview:self.policyLabel];

    
    self.privacyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.privacyButton setTitle:@"We don't post anything to Facebook" forState:UIControlStateNormal];
    
    [self.privacyButton addTarget:self action:@selector(privacyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.privacyButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [self.privacyButton setTitleColor:[UIColor colorWithRed:73.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.mainView addSubview:self.privacyButton];
    
    
    self.fbLogin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/12, 0, self.view.frame.size.width/1.2, 40)];
    [self.fbLogin setTitle:@"Log In with Facebook" forState:UIControlStateNormal];
    [self.fbLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fbLogin.layer.cornerRadius = 5;
    self.fbLogin.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:153.0/255.0 alpha:1.0];
    
    [self.fbLogin addTarget:self action:@selector(FBLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.fbLogin.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [self.mainView addSubview:self.fbLogin];
}

- (void)addPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 0, 100, 50)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.mainView addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark - Button Actions
- (void)FBLoginButtonPressed:(UIButton *)sender {
//    PFUser *user = [PFUser user];
//    user.username = @"jacky";
//    user.password = @"jacky";
//    user.email = @"email@gmail.com";
//    
//    user[@"phone"] = @"650-500-0000";
//    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (!error) {
//            // hoooo
//        } else
//        {
//            NSString *errorString = [error userInfo][@"error"];
//        }
//    }];
    [self _loginWithFacebook];
}

- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
        [self FBSignAlert:@"Uh oh. The user cancelled the Facebook login."];
            
        } else if (user.isNew) {
//            [self FBSignAlert:@"User signed up and logged in through Facebook!"];
            [self LogIned];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
        } else {
//            [self FBSignAlert:@"User logged in through Facebook!"];
            [self LogIned];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
        }
    }];
}

- (void) LogIned
{
    UIColor *orange = [UIColor colorWithRed:255/255
                                      green:69.0/255
                                       blue:0.0/255
                                      alpha:1.0];
    
    UIColor *gray = [UIColor colorWithRed:.84
                                    green:.84
                                     blue:.84
                                    alpha:1.0];
    
    // Make views for the navigation bar
    UIImage *img1 = [UIImage imageNamed:@"gear"];
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *img2 = [UIImage imageNamed:@"tinder"];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //    UIcImage *img3 = [UIImage imageNamed:@"tindericon"];
    //    img3 = [img3 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *img4 = [UIImage imageNamed:@"chat"];
    img4 = [img4 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    SLPagingViewController *pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:@[[[UIImageView alloc] initWithImage:img1], [[UIImageView alloc] initWithImage:img2],[[UIImageView alloc] initWithImage:img4]]
                                                                                    navBarBackground:[UIColor whiteColor]
                                                                                               views:@[[self settingView], [self matchView], [self messageView]]
                                                                                     showPageControl:NO];
    pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    float minX = 45.0;
    // Tinder Like
    pageViewController.pagingViewMoving = ^(NSArray *subviews){
        float mid  = [UIScreen mainScreen].bounds.size.width/2 - minX;
        float midM = [UIScreen mainScreen].bounds.size.width - minX;
        for(UIImageView *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > minX
               && v.frame.origin.x < mid)
                // Left part
                c = [UIColor gradient:v.frame.origin.x
                                  top:minX+1
                               bottom:mid-1
                                 init:orange
                                 goal:gray];
            else if(v.frame.origin.x > mid
                    && v.frame.origin.x < midM)
                // Right part
                c = [UIColor gradient:v.frame.origin.x
                                  top:mid+1
                               bottom:midM-1
                                 init:gray
                                 goal:orange];
            else if(v.frame.origin.x == mid)
                c = orange;
            v.tintColor= c;
        }
    };
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.navigationController = [[UINavigationController alloc] initWithRootViewController:pageViewController];
    [appDelegate.window setRootViewController:appDelegate.navigationController];
}

- (void)privacyButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.center = CGPointMake(self.view.center.x, self.view.center.y  - self.view.frame.size.height/2 + self.fbLogin.frame.size.height*4);
        
        self.policyLabel.alpha = 0;
        self.privacyButton.alpha = 0;
        self.scrollView.alpha = 0;
        self.pageControl.alpha = 0;
        self.closeButton.alpha = 1.0;
        self.bottomView.alpha = 1.0;
        
    } completion:nil];

}

- (void)closeButtonPressed:(UIButton *)sender {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height/2);
        
        self.policyLabel.alpha = 1.0;
        self.privacyButton.alpha = 1.0;
        self.scrollView.alpha = 1.0;
        self.pageControl.alpha = 1.0;
        self.closeButton.alpha = 0;
        self.bottomView.alpha = 0;
        
    } completion:nil];
}

- (void)FBSignAlert:(NSString*)msg {
    UIAlertController* alertVC;
    
    alertVC = [UIAlertController alertControllerWithTitle:@"Login" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(UIView*)viewWithBackground{
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor yellowColor];
    return v;
}


-(UIView*)settingView{
    UIView *v = [UIView new];
    
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

-(UIView*)matchView{
    
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    
    //Creating a rounded image view.
    RoundedImageView *profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(self.view.center.x-40, self.view.center.y-160, 80, 80)];
    
    //Configring the rounded imageview by setting appropriate image and offset.
    profileImageView.imageOffset = 2.5;
    profileImageView.image = [UIImage imageNamed:@"profile_pic.jpg"];
    profileImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large.png"];
    
    //Adding rounded image view to main view.
    [v addSubview:profileImageView];
    
    UIButton *purchasebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-154, 94, 94)];
    
    [purchasebtn setImage:[UIImage imageNamed:@"repost"] forState:UIControlStateNormal];
    [purchasebtn addTarget:self action:@selector(purchasebtnpreesed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:purchasebtn];
    
    UIButton *superlikebtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-10-94, self.view.frame.size.height-154, 94, 94)];
    
    [superlikebtn setImage:[UIImage imageNamed:@"superlike"] forState:UIControlStateNormal];
    [superlikebtn addTarget:self action:@selector(superlikebtnpreesed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:superlikebtn];
    
    UIButton *likebtn = [[UIButton alloc] initWithFrame:CGRectMake(10+70, self.view.frame.size.height-149, 94, 94)];
    
    [likebtn setImage:[UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    [likebtn addTarget:self action:@selector(unlikebtnpreesed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:likebtn];
    
    UIButton *unlikebtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-10-94-70, self.view.frame.size.height-149, 94, 94)];
    
    [unlikebtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [unlikebtn addTarget:self action:@selector(likebtnpreesed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:unlikebtn];
    
    UILabel *descriplbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.frame.size.width/2, self.view.frame.size.height-280, self.view.frame.size.width, 60)];
    descriplbl.numberOfLines = 2;
    descriplbl.textAlignment = NSTextAlignmentCenter;
    descriplbl.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
    [descriplbl setFont:[UIFont systemFontOfSize:14]];
    
    descriplbl.text = @"There's not one new around you. \nUse Passport to choose a new location.";
    
    [v addSubview:descriplbl];
    
    return v;
}

-(UIView*)messageView{
    
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-100, 50, 200, 200)];
    ImageView.image = [UIImage imageNamed:@"messageEmpty"];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.frame.size.width/2, 270, self.view.frame.size.width, 50)];
    titleLbl.numberOfLines = -1;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
    [titleLbl setFont:[UIFont boldSystemFontOfSize:18]];
    
    titleLbl.text = @"Get Swiping";
    
    UILabel *descripLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - self.view.frame.size.width/2, 300, self.view.frame.size.width, 100)];
    descripLbl.numberOfLines = 3;
    descripLbl.textAlignment = NSTextAlignmentCenter;
    descripLbl.textColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];
    [descripLbl setFont:[UIFont systemFontOfSize:14]];
    
    descripLbl.text = @"When you match with other users \nthey'll appear here where you can send\nthem a message";
    
    [v addSubview:titleLbl];
    [v addSubview:descripLbl];
    [v addSubview:ImageView];
    
    return v;
}


#pragma mark - Button Actions
- (void)purchasebtnpreesed:(UIButton *)sender {
    
}

- (void)superlikebtnpreesed:(UIButton *)sender
{
    
}

- (void)likebtnpreesed:(UIButton *)sender
{
    
}

- (void)unlikebtnpreesed:(UIButton *)sender
{
    
}

@end
