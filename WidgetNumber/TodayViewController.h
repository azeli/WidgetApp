//
//  TodayViewController.h
//  WidgetNumber
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFileManager.h"

@interface TodayViewController : UIViewController{
 @private
    WidgetFileManager *_fileManager;
    NSArray *_arrayName;
    NSArray *_arraySpecification;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
