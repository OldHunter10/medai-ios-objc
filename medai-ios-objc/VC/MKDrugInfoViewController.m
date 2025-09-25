//
//  MKDrugInfoViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/9/25.
//

#import "MKDrugInfoViewController.h"

@interface MKDrugInfoViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextView *resultTextView;
@property (nonatomic, strong) UIButton *randomButton;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *drugDatabase;

@end

@implementation MKDrugInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Drug Info";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.drugDatabase = @{
        @"paracetamol": @"Paracetamol is used to treat mild to moderate pain and reduce fever.",
        @"ibuprofen": @"Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) used for pain, swelling, and fever.",
        @"amoxicillin": @"Amoxicillin is an antibiotic used to treat a number of bacterial infections.",
        @"cetirizine": @"Cetirizine is an antihistamine used to relieve allergy symptoms.",
        @"omeprazole": @"Omeprazole reduces stomach acid and is used for heartburn, ulcers, and reflux."
    };
}

- (void)setupUI {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Search drug name (e.g. ibuprofen)";
    self.searchBar.delegate = self;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    
    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.editable = NO;
    self.resultTextView.font = [UIFont systemFontOfSize:16];
    self.resultTextView.layer.borderWidth = 1.0;
    self.resultTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resultTextView.layer.cornerRadius = 8;
    self.resultTextView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    self.resultTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.resultTextView];
    
    self.randomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.randomButton setTitle:@"Random Drug" forState:UIControlStateNormal];
    [self.randomButton addTarget:self action:@selector(handleRandomTapped) forControlEvents:UIControlEventTouchUpInside];
    self.randomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.randomButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.searchBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        
        [self.resultTextView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:16],
        [self.resultTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.resultTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.resultTextView.heightAnchor constraintEqualToConstant:200],
        
        [self.randomButton.topAnchor constraintEqualToAnchor:self.resultTextView.bottomAnchor constant:20],
        [self.randomButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [self lookupDrugWithName:searchBar.text];
}

- (void)lookupDrugWithName:(NSString *)name {
    if (name.length == 0) {
        self.resultTextView.text = @"Please enter a drug name.";
        return;
    }
    
    NSString *key = [name.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *info = self.drugDatabase[key];
    
    if (info) {
        self.resultTextView.text = info;
    } else {
        self.resultTextView.text = @"No information found for that drug.";
    }
}

#pragma mark - Random Button

- (void)handleRandomTapped {
    NSArray *allKeys = self.drugDatabase.allKeys;
    if (allKeys.count == 0) return;
    
    NSString *randomKey = allKeys[arc4random_uniform((uint32_t)allKeys.count)];
    self.searchBar.text = randomKey;
    [self lookupDrugWithName:randomKey];
}

@end
