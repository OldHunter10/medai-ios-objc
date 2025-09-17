//
//  MKHistoryViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/31.
//

#import "MKHistoryViewController.h"
#import "HistoryManager.h"

@interface MKHistoryViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *historyItems;
@property (nonatomic, strong) NSArray<NSDictionary *> *filteredItems;
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
    
    // 搜索框
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Search past symptom inputs";
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.tableView.tableHeaderView = self.searchBar;
    
    // 清空按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Clear"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(clearHistoryTapped)];
    
    // 长按删除
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.tableView addGestureRecognizer:longPress];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textColor = [UIColor grayColor];
    countLabel.tag = 999;

    [self.view addSubview:countLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.historyItems = [HistoryManager loadHistory];
    self.filteredItems = self.historyItems;
    [self.tableView reloadData];
}

#pragma mark - Long Press to Delete

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (!indexPath || indexPath.row >= self.filteredItems.count) return;

    NSDictionary *entry = self.filteredItems[indexPath.row];
    NSString *text = entry[@"text"] ?: @"";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Record"
                                                                   message:@"Are you sure you want to remove this entry?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [HistoryManager deleteRecord:text];
        self.historyItems = [HistoryManager loadHistory];
        self.filteredItems = self.historyItems;
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredItems = self.historyItems;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *text = item[@"text"] ?: @"";
            return [text.lowercaseString containsString:searchText.lowercaseString];
        }];
        self.filteredItems = [self.historyItems filteredArrayUsingPredicate:predicate];
    }
    
    UILabel *label = [self.view viewWithTag:999];
    label.text = [NSString stringWithFormat:@"%lu result%@", (unsigned long)self.filteredItems.count, self.filteredItems.count == 1 ? @"" : @"s"];
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Clear All

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

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    NSDictionary *entry = self.filteredItems[indexPath.row];
    cell.textLabel.text = entry[@"text"];
    cell.detailTextLabel.text = entry[@"date"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selected = self.filteredItems[indexPath.row][@"text"];
    NSLog(@"Selected history: %@", selected);

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
