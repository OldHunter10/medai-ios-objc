//
//  MKSettingsViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/8/2.
//

#import "MKSettingsViewController.h"
#import "HistoryManager.h"

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
        @[@"Language (English / 中文)", @"AI Model (Simple)"],
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
    
    // Fake model / language selection highlight
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.detailTextLabel.text = @"Simple";
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self confirmClearHistory];
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

@end
