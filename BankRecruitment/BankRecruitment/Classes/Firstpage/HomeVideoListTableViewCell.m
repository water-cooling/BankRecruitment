//
//  OilPriceTrendCell.m
//  YLTX
//
//  Created by boyce.huang on 2017/11/2.
//  Copyright © 2017年 huangpf. All rights reserved.
//

#import "HomeVideoListTableViewCell.h"
#import "VideoSelectCollectionViewCell.h"
@interface HomeVideoListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UILabel * lbl_address;
@property(nonatomic,strong)UICollectionView * collect_my;
@property(nonatomic,strong) NSMutableArray *arr_centerArr;
@end
@implementation HomeVideoListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     [self addCenterView];
    }
    return self;
}
-(void)addCenterView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(Screen_Width-49, 98.5);
    layout.minimumInteritemSpacing = 21.5;
    _collect_my = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,98.5) collectionViewLayout:layout];
    _collect_my.delegate = self;
    _collect_my.dataSource = self;
    _collect_my.backgroundColor = [UIColor whiteColor];
    [_collect_my registerNib:[UINib nibWithNibName:@"VideoSelectCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"cellId"];
    [self addSubview:_collect_my];
}
#pragma mark collection deleget

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr_centerArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    _selectionHandle(indexPath.row);
}

-(NSMutableArray *)arr_centerArr{
    if (!_arr_centerArr) {
        _arr_centerArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _arr_centerArr;
}

@end
