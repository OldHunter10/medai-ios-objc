//
//  MKSettingsViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/2.
//

#import "MKSettingsViewController.h"
#import "HistoryManager.h"

static NSString * const kSelectedModelKey = @"selected_model";

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
        @[@"Language (English / 中文)", @"AI Model"],
        @[@"App Version"]
    ];
}

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 1 && indexPath.row == 1) {
        NSString *selectedModel = [[NSUserDefaults standardUserDefaults] stringForKey:kSelectedModelKey] ?: @"Simple";
        cell.detailTextLabel.text = selectedModel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self confirmClearHistory];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self presentModelSelector];
    }
}

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
            [[NSUserDefaults standardUserDefaults] setObject:model forKey:kSelectedModelKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }];
        [alert addAction:action];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = self.view.bounds;

    [self presentViewController:alert animated:YES completion:nil];
}

@end
