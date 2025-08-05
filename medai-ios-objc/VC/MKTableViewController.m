//
//  MKTableViewController.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "MKTableViewController.h"

@interface MKTableViewController ()

@property (nonatomic, strong) NSArray<NSString *> *items;

@end

@implementation MKTableViewController

- (instancetype)initWithItems:(NSArray<NSString *> *)items {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _items = items;
        self.title = @"Items";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.rowHeight = 50;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.items[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // optional
    
    return cell;
}

#pragma mark - Table view delegate (optional)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Example action
    NSString *selected = self.items[indexPath.row];
    NSLog(@"Selected: %@", selected);
    
}

@end
