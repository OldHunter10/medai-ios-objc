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

@interface MKHomeViewController ()

@property (nonatomic, strong) UITextField *symptomInputField;
@property (nonatomic, strong) UIButton *analyzeButton;
@property (nonatomic, strong) UITextView *resultTextView;

@end

@implementation MKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Symptom Analyzer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
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
    ]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];

}

//show his
- (void)showHistory {
    MKHistoryViewController *historyVC = [[MKHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)handleAnalyzeButtonTapped {
    NSString *inputText = self.symptomInputField.text;
    
    if (inputText.length == 0) {
        self.resultTextView.text = @"Please enter at least one symptom.";
        return;
    }

    self.resultTextView.text = @"Analysing...";

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *result = [SymptomAnalyzer analyzeSymptomsFromText:inputText];
        [self displayResult:result];
    });
    
    //
    [HistoryManager saveQuery:inputText];
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
}

@end
