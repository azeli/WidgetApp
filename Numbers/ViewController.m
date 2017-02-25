//
//  ViewController.m
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "ViewController.h"
#import "TodayViewController.h"
#import "FileManager.h"


@interface ViewController ()

@property (nonatomic, strong) FileManager *fileManager;
@property (nonatomic, strong) NSNumber *randomNumber;
@property (nonatomic, strong) NSString *randomNumberString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *dataArray = [NSMutableArray new];
    
    self.fileManager = [[FileManager alloc] initWithApplicationGroupIdentifier:@"group.com.digdes.ExtensionSharing" optionalDirectory:nil];
    
    [self.fileManager listenForMessageWithIdentifier:@"buttonKey" listener:^(id messageObject) {
        self.randomNumber = @(arc4random() % 100);
        self.randomNumberString = [self.randomNumber stringValue];
        for (int i=0; i<1; i++) {
            int randomNumber = arc4random() % 100;
            [dataArray addObject:@{@"name":[NSString stringWithFormat:@"%d name", randomNumber], @"text":[NSString stringWithFormat:@"%d first line \nsecond line", randomNumber]}];
        }
        [self.fileManager passMessageObject:@{@"dataKey" : dataArray } identifier:@"data"];
        NSLog(@"%@",dataArray);

    }];
}


@end

