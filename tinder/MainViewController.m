//
//  MainViewController.m
//  Tinder Clone
//
//  Created by Ren He on 2016-02-13.
//  Copyright © 2016 Ren He. All rights reserved.
//

#import "MainViewController.h"

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
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)setUpNavigationBar {
    self.navigationController.hidesBarsOnSwipe = NO;
    
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
