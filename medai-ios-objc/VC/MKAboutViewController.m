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
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 20;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [scrollView addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor constant:40],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor constant:-40],
        [stackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-60],
    ]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"MedAI";
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.textColor = [UIColor grayColor];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"AI-assisted symptom exploration tool.";
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.text = @"Developed by JC";
    authorLabel.font = [UIFont italicSystemFontOfSize:14];
    authorLabel.textColor = [UIColor darkGrayColor];
    
    UIButton *githubButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [githubButton setTitle:@"View on GitHub" forState:UIControlStateNormal];
    [githubButton addTarget:self action:@selector(openGitHub) forControlEvents:UIControlEventTouchUpInside];
    
    [stackView addArrangedSubview:titleLabel];
    [stackView addArrangedSubview:versionLabel];
    [stackView addArrangedSubview:descLabel];
    [stackView addArrangedSubview:authorLabel];
    [stackView addArrangedSubview:githubButton];
}

- (void)openGitHub {
    NSURL *url = [NSURL URLWithString:@"https://github.com/oldhunter10/medai-ios-objc"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
