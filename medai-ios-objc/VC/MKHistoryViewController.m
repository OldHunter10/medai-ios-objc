//
//  MKHistoryViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import "MKHistoryViewController.h"
#import "HistoryManager.h"

@interface MKHistoryViewController ()

@property (nonatomic, strong) NSArray<NSString *> *historyItems;

@end

@implementation MKHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"History";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.historyItems = [HistoryManager loadHistory];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.historyItems[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selected = self.historyItems[indexPath.row];
    NSLog(@"Selected history: %@", selected);
    
    // TODO: optionally auto-analyse again
}

@end
