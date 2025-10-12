//
//  MKSymptomGuideViewController.m
//  medai-ios-objc
//
//  Created by ChatGPT on 2025/9/26.
//

#import "MKSymptomGuideViewController.h"

@interface MKSymptomGuideViewController ()

@property (nonatomic, strong) NSDictionary<NSString *, NSDictionary *> *symptomGuide;
@property (nonatomic, strong) NSArray<NSString *> *symptomList;

@end

@implementation MKSymptomGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Symptom Guide";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SymptomCell"];
    
    [self setupData];
}

- (void)setupData {
    self.symptomGuide = @{
        @"Headache": @{
            @"department": @"Neurology",
            @"tips": @"Could be caused by tension, migraine, or other factors. Seek help if persistent."
        },
        @"Cough": @{
            @"department": @"Respiratory",
            @"tips": @"May be due to cold, bronchitis, or allergies. If fever is present, consult a doctor."
        },
        @"Chest Pain": @{
            @"department": @"Cardiology / Emergency",
            @"tips": @"Can be serious. If it's persistent or with shortness of breath, go to the ER."
        },
        @"Fever": @{
            @"department": @"Infectious Disease / General Practice",
            @"tips": @"Monitor temperature. Seek help if it lasts more than 2 days or is very high."
        },
        @"Abdominal Pain": @{
            @"department": @"Gastroenterology",
            @"tips": @"Could be indigestion, gastritis, or appendix-related. Observe closely."
        }
    };
    
    self.symptomList = [[self.symptomGuide allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.symptomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SymptomCell" forIndexPath:indexPath];
    cell.textLabel.text = self.symptomList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *symptom = self.symptomList[indexPath.row];
    NSDictionary *info = self.symptomGuide[symptom];
    
    NSString *department = info[@"department"];
    NSString *tips = info[@"tips"];
    
    NSString *message = [NSString stringWithFormat:@"Recommended Department:\n%@\n\nTips:\n%@", department, tips];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:symptom
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
