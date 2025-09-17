//
//  MKHomeViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "MKHomeViewController.h"
#import "SymptomAnalyzer.h"
#import "HistoryManager.h"
#import "MKHistoryViewController.h"

@interface MKHomeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *symptomInputField;
@property (nonatomic, strong) UIButton *analyzeButton;
@property (nonatomic, strong) UITextView *resultTextView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView; // for loading spinner
@property (nonatomic, strong) UIButton *cpResultButton;

@end

@implementation MKHomeViewController

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Symptom Analyzer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.symptomInputField.delegate = self;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    // NSLog(@"dismissed keyboard"); // worked better than resignFirstResponder
}

- (void)setupUI {
    self.symptomInputField = [[UITextField alloc] init];
    self.symptomInputField.placeholder = @"Enter symptoms (e.g. fever headache)";
    self.symptomInputField.borderStyle = UITextBorderStyleRoundedRect;
    self.symptomInputField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.symptomInputField];
    
    self.analyzeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.analyzeButton setTitle:@"Analyse" forState:UIControlStateNormal];
    self.analyzeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.analyzeButton addTarget:self action:@selector(handleAnalyzeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.analyzeButton];
    
    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.editable = NO;
    self.resultTextView.font = [UIFont systemFontOfSize:16];
    self.resultTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultTextView];
    
    self.cpResultButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cpResultButton setTitle:@"Copy Result" forState:UIControlStateNormal];
    self.cpResultButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cpResultButton addTarget:self action:@selector(handleCopyTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cpResultButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.cpResultButton.topAnchor constraintEqualToAnchor:self.resultTextView.bottomAnchor constant:8],
        [self.cpResultButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    UIButton *pasteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [pasteButton setTitle:@"Paste" forState:UIControlStateNormal];
    pasteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [pasteButton addTarget:self action:@selector(handlePasteTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pasteButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.symptomInputField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.symptomInputField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.symptomInputField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.symptomInputField.heightAnchor constraintEqualToConstant:40],
        
        [self.analyzeButton.topAnchor constraintEqualToAnchor:self.symptomInputField.bottomAnchor constant:16],
        [self.analyzeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.resultTextView.topAnchor constraintEqualToAnchor:self.analyzeButton.bottomAnchor constant:20],
        [self.resultTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.resultTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.resultTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
        
        [pasteButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [pasteButton.centerYAnchor constraintEqualToAnchor:self.symptomInputField.centerYAnchor]
    ]];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.loadingView.color = [UIColor redColor]; // weird in dark mode
    [self.view addSubview:self.loadingView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.resultTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
        
        [self.loadingView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingView.topAnchor constraintEqualToAnchor:self.analyzeButton.bottomAnchor constant:8]
    ]];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [shareButton addTarget:self action:@selector(handleShareTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [shareButton.topAnchor constraintEqualToAnchor:self.cpResultButton.bottomAnchor constant:12],
        [shareButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];

}

- (void)handleShareTapped {
    NSString *text = self.resultTextView.text ?: @"";
    if (text.length == 0) return;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    
    // iPad 兼容
    activityVC.popoverPresentationController.sourceView = self.view;
    activityVC.popoverPresentationController.sourceRect = self.view.bounds;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)handleCopyTapped {
    NSString *text = self.resultTextView.text ?: @"";
    if (text.length == 0) return;
    
    [UIPasteboard generalPasteboard].string = text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Copied to clipboard"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)handlePasteTapped {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *copied = pasteboard.string ?: @"";
    
    if (copied.length > 0) {
        self.symptomInputField.text = copied;
    } else {
        // NSLog(@"Pasteboard is empty"); // user might be confused
    }
}

//show his
- (void)showHistory {
    MKHistoryViewController *historyVC = [[MKHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)handleAnalyzeButtonTapped {
    NSString *inputText = [self.symptomInputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (inputText.length == 0) {
        self.resultTextView.text = @"Please enter at least one symptom.";
        
        // 添加震动反馈
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [generator impactOccurred];
        
        return;
    }

    self.resultTextView.text = @"Analysing...";
    [self.loadingView startAnimating];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *result = [SymptomAnalyzer analyzeSymptomsFromText:inputText];
        [self.loadingView stopAnimating];
        
        [self displayResult:result];
    });
    
    //
    [HistoryManager saveQuery:inputText];
    
    self.symptomInputField.text = @"";
    //    self.symptomInputField.text = nil;
    
//    if (inputText.length > 3) {
//        self.symptomInputField.text = @"";
//    }
}

- (void)displayResult:(NSDictionary *)result {
    NSArray *conditions = result[@"conditions"];
    NSArray *departments = result[@"departments"];

    if (conditions.count == 0 && departments.count == 0) {
        self.resultTextView.text = @"No matching result found.";
        return;
    }

    NSMutableString *output = [NSMutableString string];
    if (conditions.count > 0) {
        [output appendString:@"Possible Conditions:\n"];
        for (NSString *condition in conditions) {
            [output appendFormat:@"- %@\n", condition];
        }
    }

    if (departments.count > 0) {
        [output appendString:@"\nRecommended Departments:\n"];
        for (NSString *dept in departments) {
            [output appendFormat:@"- %@\n", dept];
        }
    }

    self.resultTextView.text = output;
        
    // scroll back to top after updating result
    [self.resultTextView setContentOffset:CGPointZero animated:YES];
    //    [self.resultTextView scrollRangeToVisible:NSMakeRange(0, 0)]; // looked jumpy
}

#pragma mark - External Methods

- (void)populateInputWithText:(NSString *)text {
    if (text.length > 0) {
        self.symptomInputField.text = text;
        [self.symptomInputField becomeFirstResponder]; // 自动聚焦，体验好一点
    }
}


@end
