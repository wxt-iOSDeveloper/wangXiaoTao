//
//  SearchTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)setValueWithModel:(SearchResultModel *)model {
    //设置label边框颜色
    self.areaLabel.layer.borderColor = [[UIColor blueColor] CGColor];
    self.areaLabel.layer.borderWidth = 0.5f;
    
    if ([model.isChina isEqualToNumber:@1]) {
        //国内地区
        self.nationLabel.text = [model.provinceInfo objectForKey:@"name"];
        if (model.cityInfo == nil) {
            self.cityLabel.text = [model.provinceInfo objectForKey:@"name"];
        } else {
            self.cityLabel.text = [model.cityInfo objectForKey:@"name"];
        }
    } else {
        //外国地区
        self.cityLabel.text = [model.nationInfo objectForKey:@"name"];
        self.nationLabel.text = [model.nationInfo objectForKey:@"name"];
    }
    self.feedCountLabel.text = [[model.feedCount stringValue] stringByAppendingString:@"个约伴"];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
