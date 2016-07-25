//
//  SearchTableViewCell.h
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface SearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *nationLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedCountLabel;

- (void)setValueWithModel:(SearchResultModel *)model;

@end
