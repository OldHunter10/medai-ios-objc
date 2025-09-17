//
//  MKHistoryViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import "MKHistoryViewController.h"
#import "HistoryManager.h"

@interface MKHistoryViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray<NSString *> *historyItems;
@property (nonatomic, strong) NSArray<NSString *> *filteredItems;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MKHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"History";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.historyItems = [HistoryManager loadHistory];
    self.filteredItems = self.historyItems;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
    
    // 添加搜索框
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Search history...";
    self.searchBar.delegate = self;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    
    self.tableView.tableHeaderView = self.searchBar;

    // 清空按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Clear"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(clearHistoryTapped)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.historyItems = [HistoryManager loadHistory];
    self.filteredItems = self.historyItems;
    [self.tableView reloadData];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredItems = self.historyItems;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *item, NSDictionary *bindings) {
            return [item.lowercaseString containsString:searchText.lowercaseString];
        }];
        self.filteredItems = [self.historyItems filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Clear History

- (void)clearHistoryTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear History"
                                                                   message:@"Are you sure you want to delete all history?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [HistoryManager clearHistory];
        self.historyItems = @[];
        self.filteredItems = @[];
        [self.tableView reloadData];
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.textLabel.text = self.filteredItems[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selected = self.filteredItems[indexPath.row];
    NSLog(@"Selected history: %@", selected);

    // Find the MKHomeViewController and pass data back
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"MKHomeViewController")]) {
            if ([vc respondsToSelector:@selector(populateInputWithText:)]) {
                [vc performSelector:@selector(populateInputWithText:) withObject:selected];
            }
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
