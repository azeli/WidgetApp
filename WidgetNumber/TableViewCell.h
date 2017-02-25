//
//  TableViewCell.h
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *cellLabelName;
@property (nonatomic, retain) IBOutlet UILabel *cellLabelText;

@end
