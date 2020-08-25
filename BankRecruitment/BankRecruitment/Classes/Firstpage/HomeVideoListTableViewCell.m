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
@end
@implementation HomeVideoListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     [self addCenterView];
    }
    return self;
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.collect_my reloadData];
}
-(void)addCenterView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(Screen_Width-49, 98.5);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 21.5;
    _collect_my = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width,98.5) collectionViewLayout:layout];
    _collect_my.delegate = self;
    _collect_my.dataSource = self;
    _collect_my.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    [_collect_my registerNib:[UINib nibWithNibName:@"VideoSelectCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"cellId"];
    [self addSubview:_collect_my];
}
#pragma mark collection deleget

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    VideoTypeModel *model = self.dataArr[indexPath.row];
    
    cell.videoTypeLabel.text = model.VType;
    [cell.videoTypeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [LdGlobalObj sharedInstanse].fileServIp, model.picture]] placeholderImage:kDefaultHorizontalRectangleImage completed:nil];
    cell.countLabel.text = [NSString stringWithFormat:@"视频:%@", model.video_num];
    cell.chapterLabel.text = [NSString stringWithFormat:@"章节:%@", model.type_num];
    cell.videoBtn.tag = indexPath.row+100;
    [cell.videoBtn addTarget:self action:@selector(videoPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)videoPlayClick:(UIButton *)sender{
    if (self.PlayBlock) {
        self.PlayBlock(self.dataArr[sender.tag-100]);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    _selectionHandle(indexPath.row);
}

@end
