//
//  TodayViewController.m
//  WidgetNumber
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "FileManager.h"
#import "TableViewCell.h"

@interface TodayViewController ()

@property (nonatomic, strong) FileManager *fileManager;
@property (nonatomic, strong) NSArray *arrayName;
@property (nonatomic, strong) NSArray *arraySpecification;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation TodayViewController

- (IBAction)didTap:(UIButton *)sender {
    [self.fileManager passMessageObject:@{@"button" : @(1)} identifier:@"buttonKey"];
    [self viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileManager = [[FileManager alloc] initWithApplicationGroupIdentifier:@"group.com.digdes.ExtensionSharing" optionalDirectory:nil];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.fileManager listenForMessageWithIdentifier:@"data" listener:^(id messageObject) {
        NSArray *testArray = [messageObject valueForKey:@"dataKey"];
        self.arrayName = [testArray valueForKeyPath:@"name"];
        self.arraySpecification = [testArray valueForKeyPath:@"text"];
        [_tableView reloadData];
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0.0, 200.0);
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.view.bounds)/4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.cellLabelName.text = [self.arrayName objectAtIndex:indexPath.row];
    cell.cellLabelText.text = [self.arraySpecification objectAtIndex:indexPath.row];
    return cell;
}

@end
