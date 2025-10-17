//
//  MKSettingsViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/2.
//

#import "MKSettingsViewController.h"
#import "HistoryManager.h"
#import "MKFeedbackViewController.h"
#import "UserDefaultsHelper.h"
#import "MKAboutViewController.h"

static NSString * const kSelectedModelKey = @"selected_model";
static NSString * const kSelectedLanguageKey = @"selected_language";

@interface MKSettingsViewController ()

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *settings;

@end

@implementation MKSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    
    self.settings = @[
        @[@"Clear History"],
        @[@"Language", @"AI Model"],
        @[@"App Version", @"About", @"Feedback"]
    ];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settings[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }

    cell.textLabel.text = self.settings[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        if (indexPath.row == 0) {
            NSString *lang = [UserDefaultsHelper stringForKey:kSelectedLanguageKey defaultValue:@"English"];
            cell.detailTextLabel.text = lang;
        } else if (indexPath.row == 1) {
            NSString *selectedModel = [UserDefaultsHelper stringForKey:kSelectedModelKey defaultValue:@"Simple"];
            cell.detailTextLabel.text = selectedModel;
        }
    }

    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

        if (indexPath.row == 0) {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = version;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self confirmClearHistory];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self presentLanguageSelector];
        } else if (indexPath.row == 1) {
            [self presentModelSelector];
        }
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 1) {
            MKAboutViewController *aboutVC = [[MKAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        if (indexPath.row == 2) {
            MKFeedbackViewController *feedbackVC = [[MKFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
    
    }
}

#pragma mark - Actions

- (void)confirmClearHistory {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear History"
                                                                   message:@"Are you sure you want to remove all records?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [HistoryManager clearHistory];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:yes];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentModelSelector {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select AI Model"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *models = @[@"Simple", @"Advanced"];
    
    for (NSString *model in models) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:model
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            [UserDefaultsHelper setString:model forKey:kSelectedModelKey];
            [self.tableView reloadData];
        }];
        [alert addAction:action];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = self.view.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentLanguageSelector {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Language"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *languages = @[@"English", @"中文"];
    
    for (NSString *lang in languages) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:lang
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            [UserDefaultsHelper setString:lang forKey:kSelectedLanguageKey];
            [self.tableView reloadData];
        }];
        [alert addAction:action];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = self.view.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
