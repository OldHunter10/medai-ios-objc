//
//  MKFeedbackViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/7.
//

#import "MKFeedbackViewController.h"

@interface MKFeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation MKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Feedback";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self registerKeyboardNotifications];
}

- (void)setupUI {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"We’d love to hear your thoughts.";
    label.font = [UIFont systemFontOfSize:16];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView = [[UITextView alloc] init];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 8.0;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"Type your feedback here...";
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.textView addSubview:self.placeholderLabel];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitTapped) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.submitButton.enabled = NO;
    
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
        
        [self.placeholderLabel.topAnchor constraintEqualToAnchor:self.textView.topAnchor constant:8],
        [self.placeholderLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor constant:5],
        
        [self.submitButton.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:25],
        [self.submitButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    // 初始判断 placeholder 显示
    self.placeholderLabel.hidden = self.textView.text.length > 0;
}

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
    self.submitButton.enabled = textView.text.length > 0;

    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
}

- (void)submitTapped {
    if (self.textView.text.length == 0) return;

    self.submitButton.enabled = NO;

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you"
                                                                   message:@"Your feedback has been received."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.submitButton.enabled = NO;
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.textView.text = @"";
    self.placeholderLabel.hidden = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect kbFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -kbFrame.size.height / 2);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.layer.borderColor = [UIColor systemBlueColor].CGColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
