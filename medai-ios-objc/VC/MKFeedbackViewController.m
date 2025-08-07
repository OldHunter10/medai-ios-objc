//
//  MKFeedbackViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/7.
//

#import "MKFeedbackViewController.h"

@interface MKFeedbackViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation MKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Feedback";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"We’d love to hear your thoughts.";
    label.font = [UIFont systemFontOfSize:16];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView = [[UITextView alloc] init];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 8.0;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:label];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.textView.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:20],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.textView.heightAnchor constraintEqualToConstant:150],
        
        [self.submitButton.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:25],
        [self.submitButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)submitTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you"
                                                                   message:@"Your feedback has been received."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.textView.text = @"";
}

@end
