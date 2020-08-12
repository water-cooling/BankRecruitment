//
//  OilPriceTrendCell.h
//  YLTX
//
//  Created by boyce.huang on 2017/11/2.
//  Copyright © 2017年 huangpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTypeModel.h"
@interface HomeVideoListTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,copy)void(^PlayBlock)(VideoTypeModel *model);
@end
