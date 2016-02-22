//
//  MainViewController.m
//  Tinder Clone
//
//  Created by Ren He on 2016-02-13.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import "MainViewController.h"
#import <SLPagingView/SLPagingViewController.h>
#import "RoundedImageView.h"
#import "UIColor+SLAddition.h"

@interface MainViewController ()
@property (nonatomic) UIBarButtonItem *backButton;
@property (nonatomic) UIBarButtonItem *messageButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"MainViewController loaded");
    [self setUpNavigationBar];
    // self.view.backgroundColor = [UIColor blueColor];
    
    
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
    
//    self.nav = [[UINavigationController alloc] initWithRootViewController:pageViewController];
//    [self.window setRootViewController:self.nav];
//    
//    [self setWindow:self.window];
    
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];

    [pageViewController didMoveToParentViewController:self];
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

- (void)setUpNavigationBar {
    self.navigationController.hidesBarsOnSwipe = YES;
    
    self.backButton = [[UIBarButtonItem alloc]
                       initWithImage:[UIImage imageNamed:@"BackIcon"]
                       style:UIBarButtonItemStylePlain
                       target:self
                       action:@selector(backButtonPressed:)];
    self.backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigationBar Button Actions

- (void)messageButtonPressed:(UIBarButtonItem *)barButton {
    
}

- (void)backButtonPressed:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
