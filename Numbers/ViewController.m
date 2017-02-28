//
//  ViewController.m
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "ViewController.h"
#import "TodayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *dataArray = [NSMutableArray new];
    
    FileManager *fileManager = [[FileManager alloc] initWithApplicationGroupIdentifier:@"group.com.digdes.ExtensionSharing" optionalDirectory:nil];
    
    [fileManager listenForMessageWithIdentifier:@"buttonKey" listener:^(id messageObject) {
        for (int i=0; i<1; i++) {
            NSNumber *randomNumber = @(arc4random() % 100);
            [dataArray addObject:@{@"name":[NSString stringWithFormat:@"%@ name", randomNumber], @"text":[NSString stringWithFormat:@"%@ first line \nsecond line", randomNumber]}];
        }
        [fileManager passMessageObject:@{@"dataKey" : dataArray } identifier:@"data"];
        NSLog(@"%@",dataArray);
    }];
}


@end

