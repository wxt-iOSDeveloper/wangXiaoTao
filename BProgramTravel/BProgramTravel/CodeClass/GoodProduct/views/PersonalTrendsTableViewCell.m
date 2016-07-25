//
//  PersonalTrendsTableViewCell.m
//  BProgramTravel
//
//  Created by lanouhn on 16/5/17.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "PersonalTrendsTableViewCell.h"
#import "NetworkingManager.h"
#import "UIImageView+AFNetworking.h"

@implementation PersonalTrendsTableViewCell


- (void)setValueFromModel:(TrendsModel *)model {
    self.passModel = model;
    
    self.contentLabel.text = [model.feed objectForKey:@"content"];
    CGFloat height = [self contentLabelHeightWithContent:[model.feed objectForKey:@"content"]];
    if (height > 200) {
        height = 200;//保证contentLabel的高度不能太高
    }
    CGRect rect = self.contentLabel.frame;
    rect.size.height = height;
    self.contentLabel.frame = rect;
    //有的用户没有位置信息
    //<null>是对象 判断的时候也需要用对象来判断
    if (![[model.feed objectForKey:@"location"] isEqual:[NSNull null]]) {
        self.locationLabel.text = [model.feed objectForKey:@"location"];
        [self.locationImageView setImage:[UIImage imageNamed:@"weizhi.png"]];
    }
    if (model.praiseId) {
        [self.praiseImageView setImage:[UIImage imageNamed:@"yishoucang.png"]];
    } else {
        [self.praiseImageView setImage:[UIImage imageNamed:@"shoucang.png"]];
    }
    self.praiseImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *praiseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseTapAction:)];
    [self.praiseImageView addGestureRecognizer:praiseTap];
    
    self.praiseLabel.text = [model.praiseCount stringValue];
    
    self.commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *commentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapAction:)];
    [self.commentImageView addGestureRecognizer:commentTap];
    
    self.commentLabel.text = [model.replyCount stringValue];
    //给图片区view赋值
    if (model.pictureList.count <= 3 && model.pictureList.count != 0) {
        CGRect rect = self.addPictureView.frame;
        rect.size.height = 80;
        self.addPictureView.frame = rect;
    } else if (model.pictureList.count > 3 && model.pictureList.count <= 6) {
        CGRect rect = self.addPictureView.frame;
        rect.size.height = 165;
        self.addPictureView.frame = rect;
    } else if (model.pictureList.count == 0){
        CGRect rect = self.addPictureView.frame;
        rect.size.height = 0;
        self.addPictureView.frame = rect;
    } else {
        CGRect rect = self.addPictureView.frame;
        rect.size.height = 250;
        self.addPictureView.frame = rect;
    }
    for (int i = 0; i < model.pictureList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 3 * 85, i / 3 * 85, 80, 80)];
        NSString *imageUrl = [[model.pictureList objectAtIndex:i] objectForKey:@"url"];
        [imageView setImageWithURL:[NSURL URLWithString:[kImageURL stringByAppendingString:imageUrl]]];
        [self.addPictureView addSubview:imageView];
    }
    //给发表时间label赋值
    self.timeLabel.text = [[NetworkingManager sharedNetWorkingMangaer] caculateTimeWithString:[model.feed objectForKey:@"addTime"]];
    

    
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
                self.praiseLabel.text = [self.passModel.praiseCount stringValue];
            }
        } error:^(NSError *error) {
            
        }];
    } else {
        // 不存在 则没赞  改为已赞状态
        [NetworkingManager requestPOSTWithUrlString:kPraiseURL parDic:@{@"sToken":ksToken,@"praise":[self.passModel.author objectForKey:@"name"],@"sourceId":kUserId,@"toUserId":[self.passModel.author objectForKey:@"userId"],@"userId":[self.passModel.feed objectForKey:@"feedId"]} finish:^(id responseObject) {
            NSLog(@"~~~%@",responseObject);
            if ([responseObject objectForKey:@"id"]) {
                //id存在 证明请求成功  赞的数量加1
                self.passModel.praiseId = [responseObject objectForKey:@"id"];//记录点赞的id
                [self.praiseImageView setImage:[UIImage imageNamed:@"yishoucang.png"]];
                self.passModel.praiseCount = [NSNumber numberWithInt:[self.passModel.praiseCount intValue] + 1];
                self.praiseLabel.text = [self.passModel.praiseCount stringValue];
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
    self.contentLabel.frame = CGRectMake(32, 58, [UIScreen mainScreen].bounds.size.width - 64, LabelHeight);
    self.contentLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentLabel setNumberOfLines:0];//多行显示
    self.addPictureView.frame = CGRectMake(32, 58 + LabelHeight + 5, [UIScreen mainScreen].bounds.size.width - 64, viewHeight);
    [self.cellView addSubview:self.contentLabel];
    [self.cellView addSubview:self.addPictureView];
}

- (void)awakeFromNib {
    //可视化才会走的方法
    //相当于重写init
    self.contentLabel = [[UILabel alloc] init];
    self.addPictureView = [[UIView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
