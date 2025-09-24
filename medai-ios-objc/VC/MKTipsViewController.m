//
//  MKTipsViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/9/24.
//

#import "MKTipsViewController.h"

@interface MKTipsViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;

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

#pragma mark - Setup

- (void)setupTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.scrollEnabled = YES;
    self.textView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    self.textView.textColor = [UIColor darkTextColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.textView.layer.shadowOpacity = 0.05;
    self.textView.layer.shadowOffset = CGSizeMake(0, 2);
    self.textView.layer.shadowRadius = 4;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(20, 16, 20, 16);
    
    [self.view addSubview:self.textView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.textView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.textView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16]
    ]];
}

#pragma mark - Load Tips

- (void)loadTips {
    NSArray<NSString *> *tips = @[
        @"Describe your symptoms clearly, including duration and severity.",
        @"Combine multiple symptoms (e.g. 'headache + fever') for better results.",
        @"Use the 'History' tab to review or re-run past queries.",
        @"Long press on a history item to delete it.",
        @"Use 'Copy' and 'Share' to keep or send your results.",
        @"For emergencies, always contact your doctor."
    ];
    
    NSMutableString *formattedTips = [NSMutableString stringWithString:@"💡 Helpful Tips:\n\n"];
    
    for (NSString *tip in tips) {
        [formattedTips appendFormat:@"• %@\n\n", tip];
    }
    
    self.textView.text = formattedTips;
    
}

@end
