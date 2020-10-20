//
//  typeSelectView.m
//  YLTX
//
//  Created by yltx on 2019/11/13.
//  Copyright © 2019 huangpf. All rights reserved.
//

#import "AlerSignView.h"
@interface AlerSignView ()

@property (nonatomic, strong)  UIImageView*signBackImg;
@property (nonatomic, strong)  UILabel*signDayLab;
@end

@implementation AlerSignView

-(instancetype)initWithFrame:(CGRect)frame withSignDay:(NSString *)str{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [[UIColor colorWithHex:@"#000000"]colorWithAlphaComponent:0.4];
        self.signBackImg = [[UIImageView alloc]init];
        self.signBackImg.image = [UIImage imageNamed:@"签到成功"];
        [self addSubview:self.signBackImg];
        [self.signBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        self.signDayLab = [[UILabel alloc]init];
        self.signDayLab.textColor = [UIColor blackColor];
        self.signDayLab.text = str;
        self.signDayLab.font = [UIFont systemFontOfSize:20];
        [self.signBackImg addSubview:self.signDayLab];
        [self.signDayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.signBackImg);
        }];
    }
    return self;
}



@end
