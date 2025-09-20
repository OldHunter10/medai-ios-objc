//
//  MKUserViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "MKUserViewController.h"

@interface MKUserViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation MKUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"User";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"person.circle.fill"]];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarImageView.tintColor = [UIColor systemGrayColor];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.layer.cornerRadius = 50;
    self.avatarImageView.clipsToBounds = YES;
    [self.view addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"JC Gu";
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.nameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nameLabel];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.text = @"jcg@qq.com";
    self.emailLabel.font = [UIFont systemFontOfSize:16];
    self.emailLabel.textColor = [UIColor grayColor];
    self.emailLabel.textAlignment = NSTextAlignmentCenter;
    self.emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.emailLabel];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    [self.logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];

    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton addTarget:self action:@selector(handleLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.avatarImageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        [self.avatarImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.avatarImageView.widthAnchor constraintEqualToConstant:100],
        [self.avatarImageView.heightAnchor constraintEqualToConstant:100],
        
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.avatarImageView.bottomAnchor constant:20],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.emailLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:8],
        [self.emailLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.emailLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.logoutButton.topAnchor constraintEqualToAnchor:self.emailLabel.bottomAnchor constant:30],
        [self.logoutButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)handleLogout {
    NSLog(@"Log out tapped (not implemented)");
}

@end
