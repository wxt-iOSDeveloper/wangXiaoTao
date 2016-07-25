//
//  TrendsTableViewCell.m
//  travelApp
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "TrendsTableViewCell.h"
#import "NetworkingManager.h"
#import "TrendsDetailViewController.h"

@implementation TrendsTableViewCell


- (void)setValueFromModel:(TrendsModel *)model {
    self.passModel = model;
    [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:[model.author objectForKey:@"picUrl"]]];
    //给imageView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //打开用户交互
    self.userHeaderImageView.userInteractionEnabled = YES;
    //将手势添加到imageView上
    [self.userHeaderImageView addGestureRecognizer:tap];
    self.userNameLabel.text = [model.author objectForKey:@"name"];
    self.contentLable.text = [model.feed objectForKey:@"content"];
    CGFloat height = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
    if (height > 200) {
        height = 200;//保证contentLabel的高度不能太高
    }
//    CGRect rect = self.contentLable.frame;
//    rect.size.height = height;
    self.contentLable.frame = CGRectMake(28, 55, kDeviceWidth - 28 * 2, height);
    //有的用户没有位置信息
    //<null>是对象 判断的时候也需要用对象来判断
    NSString *locationStr = [model.feed objectForKey:@"location"];
    if (![locationStr isEqual:[NSNull null]]) {
        if (locationStr.length != 0) {
            self.locationLabel.text = [model.feed objectForKey:@"location"];
            [self.locationImageView setImage:[UIImage imageNamed:@"weizhi.png"]];
        }
    }
    if (model.praiseId) {
        [self.praiseImageView setImage:[UIImage imageNamed:@"yishoucang.png"]];
    } else {
        [self.praiseImageView setImage:[UIImage imageNamed:@"shoucang.png"]];
    }
    self.praiseImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *praiseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseTapAction:)];
    [self.praiseImageView addGestureRecognizer:praiseTap];
    
    self.praiseCountLabel.text = [model.praiseCount stringValue];
    
    self.commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction:)];
    [self.commentImageView addGestureRecognizer:commentTap];
    
    self.commentCountLabel.text = [model.replyCount stringValue];
    //给图片区view赋值
    CGFloat picHeight = 0;
    if (model.pictureList.count <= 3 && model.pictureList.count != 0) {
        picHeight = 80;
    } else if (model.pictureList.count > 3 && model.pictureList.count <= 6) {
        picHeight = 165;
    } else if (model.pictureList.count == 0){
        picHeight = 0;
    } else {
        picHeight = 250;
    }

    NSArray *array = self.addPictureView.subviews;//拿到图片区的子视图数组
    for (UIImageView *imageView in array) {//遍历数组 移除所有子视图 防止重用时会出现重复的情况
        [imageView removeFromSuperview];
    }

    self.addPictureView.frame = CGRectMake(28, 60 + height, kDeviceWidth - 56, picHeight);
    for (int i = 0; i < model.pictureList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 3 * 85, i / 3 * 85, 80, 80)];
        NSString *imageUrl = [[model.pictureList objectAtIndex:i] objectForKey:@"url"];
        [imageView setImageWithURL:[NSURL URLWithString:[kImageURL stringByAppendingString:imageUrl]]];
        [self.addPictureView addSubview:imageView];
    }
    //给发表时间label赋值
    self.addTimeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.feed objectForKey:@"addTime"]];
    
    //给关注按钮添加点击事件
    if ([[[model.author objectForKey:@"userId"] stringValue] isEqualToString:kUserId]) {
        
    } else {
        if ([model.relationType intValue] == 1) {
            //代表已关注  将关注图片改为已关注
            [self.focusButton setImage:[UIImage imageNamed:@"yiguanzhu.png"] forState:UIControlStateNormal];
        } else {
            //没有关注
            [self.focusButton setImage:[UIImage imageNamed:@"jiaguanzhu.png"] forState:UIControlStateNormal];
        }
        [self.focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
}

//点击关注按钮 进行关注或者取消关注
- (void)focusButtonAction:(UIButton *)sender {
        if ([self.passModel.relationType intValue] == 0) {
        //没有关注 进行关注
        [NetworkingManager requestPOSTWithUrlString:kGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"followUserId":[self.passModel.author objectForKey:@"userId"]} finish:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                [sender setImage:[UIImage imageNamed:@"yiguanzhu.png"] forState:UIControlStateNormal];
                self.passModel.relationType = @1;
            }
        } error:^(NSError *error) {
            
        }];
    } else {
       //确定后取消关注
        [NetworkingManager requestPOSTWithUrlString:kCancelGuanzhuURL parDic:@{@"sToken":ksToken,@"userId":kUserId,@"unfollowUserId":[self.passModel.author objectForKey:@"userId"]} finish:^(id responseObject) {
            NSLog(@"----%@", responseObject);
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                    //取消关注成功
                [sender setImage:[UIImage imageNamed:@"jiaguanzhu.png"] forState:UIControlStateNormal];
                    self.passModel.relationType = @0;
            } else {
                NSLog(@"%@", [responseObject objectForKey:@"errorReason"]);
            }
            } error:^(NSError *error) {
                
            }];
    }
}


//点击头像图片 进入用户信息界面
- (void)tapAction:(UITapGestureRecognizer *)sender {
    //调用block, 为了把当前被点击的图片的下标传递到控制器上
    if (self.tapActionBlock) {
        self.tapActionBlock(self.passModel);
    }
}

//轻拍赞图片 对动态 赞或者取消
- (void)praiseTapAction:(UITapGestureRecognizer *)sender {
    if (self.passModel.praiseId) {
        //praiseId存在 已赞过  需要取消赞
        [NetworkingManager requestPOSTWithUrlString:kCancelPraiseURL parDic:@{@"sToken":ksToken,@"id":self.passModel.praiseId} finish:^(id responseObject) {
            if ([[responseObject objectForKey:@"result"] intValue] == 1) {
                //取消成功  同时赞的数量要减一
                self.passModel.praiseId = NULL;//将对应参数清空 防止连续点击时出现bug
                [self.praiseImageView setImage:[UIImage imageNamed:@"shoucang.png"]];
                //model中的赞的数量和label上显示的都需要改 否则连续点击的时候会在取消点赞时多减少一个赞
                self.passModel.praiseCount = [NSNumber numberWithInt:[self.passModel.praiseCount intValue] - 1];
                self.praiseCountLabel.text = [self.passModel.praiseCount stringValue];
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        // 不存在 则没赞  改为已赞状态
        //NSDictionary *dic = @{@"id":@0,@"sourceId":[self.passModel.feed objectForKey:@"feedId"],@"toUserId":[self.passModel.author objectForKey:@"userId"],@"type":[self.passModel.feed objectForKey:@"type"],@"userId":kUserId};
        
        NSString *dicStr = [NSString stringWithFormat:@"{id:0,sourceId:%@,toUserId:%@,type:%@,userId:%@}",[self.passModel.feed objectForKey:@"feedId"],[self.passModel.author objectForKey:@"userId"],[self.passModel.feed objectForKey:@"type"],kUserId];
        NSDictionary *dicPara = @{@"sToken":ksToken,@"praise":dicStr};
        [NetworkingManager requestGETWithUrlString:kPraiseURL parDic:dicPara finish:^(id responseObject) {
            NSLog(@"~~~%@",responseObject);
            NSLog(@"reason:%@",responseObject[@"errorReason"]);
            if ([responseObject objectForKey:@"id"]) {
                //id存在 证明请求成功  赞的数量加1
                self.passModel.praiseId = [responseObject objectForKey:@"id"];//记录点赞的id
                [self.praiseImageView setImage:[UIImage imageNamed:@"yishoucang.png"]];
                self.passModel.praiseCount = [NSNumber numberWithInt:[self.passModel.praiseCount intValue] + 1];
                self.praiseCountLabel.text = [self.passModel.praiseCount stringValue];
            } else {
                NSLog(@"%@", [responseObject objectForKey:@"errorDetail"]);
            }
        } error:^(NSError *error) {
            NSLog(@"请求失败");
        }];
    }
}

//轻拍评论图片 进入评论页面
- (void)commentTapAction:(UITapGestureRecognizer *)sender {
    self.presentCommentBlock();
}

//计算高度
- (CGFloat)contentLabelHeightWithContent:(NSString *)contet {
    //能影响字符串高度的元素有字符串本身的字号以及展示的宽度
    //1.将计算的文本的字号进行设置
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    //2.通过以下方法计算得到字符串的高度
    //注意:参数1,用来确定文本的宽度
    //参数2:设置计量标准(比如行间距也要计算,使结果更精确)
    //参数3:确定字号大小
    CGRect rect = [contet boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 64, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

- (void)createContentLabelAndPictureView:(TrendsModel *)model {
    CGFloat LabelHeight = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
    CGFloat ammount = model.pictureList.count;
    CGFloat viewHeight = 0;
    if (ammount <= 3 && ammount > 0) {
        viewHeight = 80;
    } else if (ammount > 3 && ammount <= 6) {
        viewHeight = 165;
    } else if (ammount == 0){
        viewHeight = 0;
    } else {
        viewHeight = 250;
    }
    self.contentLable.frame = CGRectMake(32, 58, [UIScreen mainScreen].bounds.size.width - 64, LabelHeight);
    self.contentLable.font = [UIFont boldSystemFontOfSize:15];
    [self.contentLable setNumberOfLines:0];//多行显示
    self.addPictureView.frame = CGRectMake(32, 58 + LabelHeight + 5, [UIScreen mainScreen].bounds.size.width - 64, viewHeight);
    self.addPictureView.tag = 600;
    [self.cellView addSubview:self.contentLable];
    [self.cellView addSubview:self.addPictureView];
}

- (void)awakeFromNib {
    //可视化才会走的方法
    //相当于重写init
    self.contentLable = [[UILabel alloc] init];
    self.addPictureView = [[UIView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
