//
//  MKTipsViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/9/24.
//

#import "MKTipsViewController.h"

@interface MKTipsViewController ()

@end

@implementation MKTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tips";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = @"💡 Tips to get the most out of the app:\n\n• Describe your symptoms clearly.\n• Combine multiple symptoms for more accurate results.\n• You can view history anytime.\n• Long press a history item to delete.\n\nStay safe and informed!";
    textView.font = [UIFont systemFontOfSize:16];
    textView.editable = NO;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:textView];
    
    [NSLayoutConstraint activateConstraints:@[
        [textView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [textView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
    ]];
}

@end
