//
//  RecruitMentShareViewController.m
//  Recruitment
//
//  Created by yltx on 2020/8/22.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "RecruitMentShareViewController.h"
#import <UShareUI/UShareUI.h>
@interface RecruitMentShareViewController ()
@property (nonatomic, strong) NSMutableArray *shareArr;

@end

@implementation RecruitMentShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHex:@"#000000"]colorWithAlphaComponent:0.4];
    [self initShareUI];
    
}


/*  ============================================================  */
#pragma mark - InterpolatedUIImage

-(void)initShareUI{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DIsmiss)];
    [self.view addGestureRecognizer:tap];
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TabbarSafeBottomMargin);
        make.height.mas_equalTo(160);
    }];
    UILabel *titleDesLab = [UILabel new];
    titleDesLab.text = @"分享到";
    titleDesLab.textColor = [UIColor blackColor];
    titleDesLab.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:titleDesLab];
    titleDesLab.textAlignment = NSTextAlignmentCenter;
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(18);
    }];
    
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setBackgroundImage:[UIImage imageNamed:@"删除"] forState:0];
       [bottomView addSubview:cancelbtn];
       [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(bottomView).offset(-12);
           make.centerY.equalTo(titleDesLab);
       }];
       [cancelbtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchUpInside];
   
    CGFloat speator = (Screen_Width- 48*self.shareArr.count)/(self.shareArr.count+1);
    CGFloat width = 48;
    for (int i = 0; i<self.shareArr.count; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title;
        NSString *icon;
        switch ([self.shareArr[i]integerValue]) {
            case UMSocialPlatformType_WechatSession:
                title = @"微信";
                icon = @"微信";
                break;
            case UMSocialPlatformType_WechatTimeLine:
                title = @"朋友圈";
                icon = @"朋友圈";
                break;
            case UMSocialPlatformType_QQ:
                title = @"QQ好友";
                icon = @"QQ";
                break;
            case UMSocialPlatformType_Qzone:
                title = @"QQ空间";
                icon = @"QQ空间";
                    break;
            default:
                break;
        }
        [shareBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        shareBtn.tag = [self.shareArr[i]integerValue];
        [shareBtn addTarget:self action:@selector(UIClick:) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.frame = CGRectMake(speator+i*(speator+width), 65, width, width);
        [bottomView addSubview:shareBtn];

        UILabel *titleDesLab = [UILabel new];
               titleDesLab.text = title;
               titleDesLab.textColor = [UIColor blackColor];
               titleDesLab.font = [UIFont systemFontOfSize:11];
               [bottomView addSubview:titleDesLab];
               titleDesLab.textAlignment = NSTextAlignmentCenter;
        titleDesLab.frame = CGRectMake(shareBtn.xl_x, CGRectGetMaxY(shareBtn.frame)+15, width, 11);
       
    }
}



- (void)DIsmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)CancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)UIClick:(UIButton *)sender {
    switch (sender.tag) {
        case UMSocialPlatformType_WechatSession:{
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
                [self shareMusicToPlatformType:UMSocialPlatformType_WechatSession];
                
            }else{
                ZB_Toast(@"请安装微信");
            }
        }
            break;
        case UMSocialPlatformType_WechatTimeLine:{
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatTimeLine]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_WechatTimeLine];
                
            }else{
                ZB_Toast(@"请安装微信");

            }
        }
            break;
        case UMSocialPlatformType_QQ:{
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]){
                [self shareMusicToPlatformType:UMSocialPlatformType_QQ ];
            }else{
                ZB_Toast(@"请安装QQ");
            }
        }
            break;
            
        case UMSocialPlatformType_Qzone:{
            
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_Qzone];
                
            }else{
                ZB_Toast(@"请安装QQ");
            }
        }
            break;
        case UMSocialPlatformType_Sina:{
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Sina]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_Sina];
            }
            break;
        }
        default:
            break;
    }
}

- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    //设置网页地址
       //创建分享消息对象
       UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
       //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesTitle thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    shareObject.webpageUrl = self.shareWebUrl;
       //分享消息对象设置分享内容对象
       messageObject.shareObject = shareObject;
       
       //调用分享接口
       [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
           if (error) {
               ZB_Toast(@"分享失败");
               UMSocialLogInfo(@"************Share fail with error %@*********",error);
           }else{
               ZB_Toast(@"分享成功");
               if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                   UMSocialShareResponse *resp = data;
                   //分享结果消息
                   UMSocialLogInfo(@"response message is %@",resp.message);
                   //第三方原始返回的数据
                   UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                   
               }else{
                   UMSocialLogInfo(@"response data is %@",data);
               }
           }
           [self dismissViewControllerAnimated:YES completion:nil];
       }];
    
}
-(NSMutableArray *)shareArr{
    if (!_shareArr) {
        NSArray *ShareTypeArr ;
        if (self.onlyWeChat) {
             ShareTypeArr   = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)];
                _shareArr = [NSMutableArray array];
        }else{
            ShareTypeArr = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)];
            _shareArr = [NSMutableArray array];
        }
        for (NSNumber *type in ShareTypeArr) {
            if ([[UMSocialManager defaultManager]isInstall:type.integerValue]) {
                           [_shareArr addObject:type];
                }
        }
  }
    return _shareArr;
}

@end
