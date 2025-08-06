//
//  MKAboutViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/7.
//

#import "MKAboutViewController.h"

@interface MKAboutViewController ()

@end

@implementation MKAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"MedAI";
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"AI-assisted symptom exploration tool.";
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.text = @"Developed by JC";
    authorLabel.font = [UIFont italicSystemFontOfSize:14];
    authorLabel.textColor = [UIColor darkGrayColor];
    authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *githubButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [githubButton setTitle:@"View on GitHub" forState:UIControlStateNormal];
    [githubButton addTarget:self action:@selector(openGitHub) forControlEvents:UIControlEventTouchUpInside];
    githubButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:versionLabel];
    [self.view addSubview:descLabel];
    [self.view addSubview:authorLabel];
    [self.view addSubview:githubButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        
        [versionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [versionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        
        [descLabel.topAnchor constraintEqualToAnchor:versionLabel.bottomAnchor constant:20],
        [descLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [descLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.7],
        
        [authorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [authorLabel.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:30],
        
        [githubButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [githubButton.topAnchor constraintEqualToAnchor:authorLabel.bottomAnchor constant:20]
    ]];
}

- (void)openGitHub {
    NSURL *url = [NSURL URLWithString:@"https://github.com/oldhunter10/medai-ios-objc"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
