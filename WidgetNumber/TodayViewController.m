//
//  TodayViewController.m
//  WidgetNumber
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TableViewCell.h"

@interface TodayViewController ()

@end

@implementation TodayViewController

- (IBAction)didTap:(UIButton *)sender {
    [_fileManager passMessageObject:@{@"button" : @(0)} identifier:@"buttonKey"];
    [self updateArrayData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _fileManager = [[WidgetFileManager alloc] initWithApplicationGroupIdentifier:@"group.com.digdes.ExtensionSharing" optionalDirectory:nil];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateArrayData];
}

- (void)updateArrayData {
    [_fileManager listenForMessageWithIdentifier:@"data" listener:^(id messageObject) {
        NSArray *testArray = [messageObject valueForKey:@"dataKey"];
        _arrayName = [testArray valueForKeyPath:@"name"];
        _arraySpecification = [testArray valueForKeyPath:@"text"];
        [self.tableView reloadData];
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
    return [_arrayName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.cellLabelName.text = [_arrayName objectAtIndex:indexPath.row];
    cell.cellLabelText.text = [_arraySpecification objectAtIndex:indexPath.row];
    return cell;
}

@end
