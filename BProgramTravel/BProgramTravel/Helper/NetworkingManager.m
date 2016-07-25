//
//  NetworkingManager.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 WangXT. All rights reserved.
//

#import "NetworkingManager.h"
#import "AFNetworking.h"

@implementation NetworkingManager

+ (NetworkingManager *)sharedNetWorkingMangaer {
    static NetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkingManager alloc] init];
    });
    return manager;
}


//GET请求
+ (void)requestGETWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError {
    //在子线程中请求数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建请求对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //数据格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        //发起GET请求
        [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            //调用block 将数据传出去
            finish(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //调用error block,将错误信息传递出去
            conError(error);
        }];

    });
    
}

//POST请求
+ (void)requestPOSTWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError {
    //在子线程中请求数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        [manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            finish(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            conError(error);
        }];
    });
    
}


//计算时间
- (NSString *)caculateTimeWithString:(NSString *)string {
    NSDate *nowDate = [NSDate date];//0时区当前系统时间
    //日期格式对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //自定义日期格式
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    //将0时区的当前时间转换为当前时区当前时间
    NSString *dateString = [formatter stringFromDate:nowDate];
    //再将当前时区时间转换为date
    NSDateFormatter *tempformatter = [[NSDateFormatter alloc] init];
    [tempformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *nowTimeDate = [tempformatter dateFromString:dateString];
    //再将传进来的发表动态的时间转为date
    NSDate *createDate = [tempformatter dateFromString:string];
    //计算两个时间的间隔
    NSTimeInterval time = [nowTimeDate timeIntervalSinceDate:createDate];
    int hours = (int)time / 3600;
    int minute = (int)time % 3600 / 60;
    int second = (int)time % 3600 % 60;
    int hour = (int)hours % 24;
    int day = (int)hours / 24;
    if (day > 0) {
        //1.创建日期格式对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //2.自定义日期格式
        [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        //3.开始转换
        NSString *dateString = [formatter stringFromDate:createDate];
        NSString *timeString = [dateString substringFromIndex:10];
        if (day == 1) {
            NSString *dayStr = @"昨天";
            return [dayStr stringByAppendingString:timeString];
        } else if (day == 2) {
            NSString *dayStr = @"前天";
            return dayStr;
        }
        return dateString;
    } else {
        if (hour > 0) {
            //1.创建日期格式对象
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //2.自定义日期格式
            [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
            //3.开始转换
            NSString *dateStr = [formatter stringFromDate:createDate];
            NSString *timeString = [dateStr substringFromIndex:10];
            //当前时区的当前时间 dateString
            NSString *hourTimeStr = [dateString substringWithRange:NSMakeRange(8, 2)];
            int hourTime = [hourTimeStr intValue];
            if (hour > hourTime) {
                NSString *dayStr = @"昨天 ";
                return [dayStr stringByAppendingString:timeString];
            }
            return [NSString stringWithFormat:@"%d小时前",hour];//小时
        } else {
            if (minute > 0) {
                return [NSString stringWithFormat:@"%d分钟前",minute];//分钟
            } else {
                return [NSString stringWithFormat:@"%d秒前", second];//秒
            }
        }
    }
    
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
    CGRect rect = [contet boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

@end
