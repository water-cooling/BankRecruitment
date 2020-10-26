//
//  QuestionDetailViewController.m
//  Recruitment
//
//  Created by humengfan on 2020/10/17.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QAContactTableViewCell.h"
#import "DKSKeyboardView.h"
#import "QuestionListModel.h"
#import "AnswerListModel.h"
#import "MJRefresh.h"
@interface QuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DKSKeyboardDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *questionContentLab;
@property (nonatomic, strong) UILabel *contactNumLab;
@property (nonatomic, strong) UILabel *contactTitleLab;
@property (nonatomic, strong) UILabel *followNumLab;
@property (nonatomic, strong) UILabel *questionTimeLab;
@property (nonatomic, strong) UILabel *questionDetailContentLab;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSUInteger pageNo;
@property (nonatomic, strong) DKSKeyboardView *keyView;
@property (nonatomic, strong)  QuestionListModel * quesetionModel;
@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    [self drawViews];
    [self initTopHeadView];
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupRefreshTable:self.tableview needsFooterRefresh:YES];
    [self getQuestionDetailquest];
   
}
- (void)drawViews{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void)initTopHeadView{
    UIView * headView = [UIView new];
    self.headView = headView;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(StatusBarAndNavigationBarHeight);
           make.height.mas_equalTo(214.5);
       }];
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head"]];
    [headView addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.top.equalTo(headView).offset(17);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    self.userNameLab= [[UILabel alloc] init];
    self.userNameLab.font = [UIFont systemFontOfSize:12];
    self.userNameLab.textAlignment = NSTextAlignmentLeft;
    self.userNameLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.userNameLab.text = @"";
     [headView addSubview: self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(5);
        make.centerY.equalTo(self.headImg);
        
    }];
    self.questionContentLab= [[UILabel alloc] init];
    self.questionContentLab.numberOfLines = 0;
    self.questionContentLab.preferredMaxLayoutWidth = Screen_Width-24;
    self.questionContentLab.font = [UIFont boldSystemFontOfSize:15];
    self.questionContentLab.textAlignment = NSTextAlignmentLeft;
    self.questionContentLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.questionContentLab.text = @"";
    [headView addSubview: self.questionContentLab];
    [self.questionContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(headView).offset(12.5);
          make.top.equalTo(self.headImg.mas_bottom).offset(24);
        make.right.equalTo(headView).offset(-12);
        make.height.mas_equalTo(20);
    }];
    UIImageView *contactImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huida"]];
    [headView addSubview:contactImg];
    [contactImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(13);
        make.top.equalTo(self.questionContentLab.mas_bottom).offset(19);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    self.contactNumLab= [[UILabel alloc] init];
    self.contactNumLab.font = [UIFont systemFontOfSize:13];
    self.contactNumLab.textAlignment = NSTextAlignmentLeft;
    self.contactNumLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.contactNumLab.text = @"";
    [headView addSubview:self.contactNumLab];
    [self.contactNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactImg.mas_right).offset(5);
        make.centerY.equalTo(contactImg);
    }];
    UIImageView *followImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liulan"]];
    [headView addSubview:followImg];
    [followImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactNumLab.mas_right).offset(23);
        make.centerY.equalTo(contactImg);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    self.followNumLab= [[UILabel alloc] init];
    self.followNumLab.font = [UIFont systemFontOfSize:13];
    self.followNumLab.textAlignment = NSTextAlignmentLeft;
    self.followNumLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.followNumLab.text = @"";
    [headView addSubview:self.followNumLab];
    [self.followNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followImg.mas_right).offset(5);
        make.centerY.equalTo(contactImg);
    }];
    self.questionTimeLab= [[UILabel alloc] init];
    self.questionTimeLab.font = [UIFont systemFontOfSize:12];
    self.questionTimeLab.textAlignment = NSTextAlignmentRight;
    self.questionTimeLab.textColor = [UIColor colorWithHex:@"#999999"];
    self.questionTimeLab.text = @"";
    [headView addSubview:self.questionTimeLab];
    [self.questionTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).offset(-10);
        make.centerY.equalTo(contactImg);
    }];
    UIView * speatorView = [UIView new];
    speatorView.backgroundColor = [UIColor colorWithHex:@"#F3F3F3"];
    [headView addSubview:speatorView];
    [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.top.equalTo(contactImg.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    self.questionDetailContentLab= [[UILabel alloc] init];
    self.questionDetailContentLab.numberOfLines = 0;
    self.questionDetailContentLab.font = [UIFont systemFontOfSize:13];
    self.questionDetailContentLab.textAlignment = NSTextAlignmentCenter;
    self.questionDetailContentLab.textColor = [UIColor colorWithHex:@"#333333"];
    self.questionDetailContentLab.text = @"";
    [headView addSubview:self.questionDetailContentLab];
    [self.questionDetailContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-54);
        make.left.equalTo(headView).offset(54);
        make.top.equalTo(speatorView.mas_bottom).offset(16);
        make.height.mas_equalTo(54);
    }];
   
     UIView *contactView = [[UIView alloc]init];
      contactView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    [self.view addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
      UILabel *label = [[UILabel alloc] init];
        self.contactTitleLab = label;
      label.font = [UIFont boldSystemFontOfSize:13];
      label.textAlignment = NSTextAlignmentRight;
      label.textColor = [UIColor colorWithHex:@"#999999"];
      [contactView addSubview:label];
      [label mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(contactView).offset(13);
          make.top.equalTo(contactView);
      }];
    [self.view addSubview:self.tableview];
   [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(contactView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, self.view.height- 50, Screen_Width, 50)];
    //设置代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
}
-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --fresh
-(void)reloadHeaderTableViewDataSource{
    self.pageNo = 1;
    [self.tableview.mj_footer resetNoMoreData];
    [self.dataArr removeAllObjects];
    [self getAnswerListquest];
}

-(void)reloadFooterTableViewDataSource{
    self.pageNo ++;
    [self getAnswerListquest];
}

-(void)initData{
    NSMutableAttributedString *titleAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论专区（%ld）",self.quesetionModel.answerNum]];
     [titleAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, 4)];
        self.contactTitleLab.attributedText = titleAttributeString;
    self.userNameLab.text = self.quesetionModel.userNickName;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.quesetionModel.userAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.questionContentLab.text = self.quesetionModel.title;
    self.followNumLab.text = [NSString stringWithFormat:@"%ld",self.quesetionModel.viewNum];
    self.contactNumLab.text = [NSString stringWithFormat:@"%ld",self.quesetionModel.answerNum];
    self.questionTimeLab.text = self.quesetionModel.addTime;
    self.questionDetailContentLab.text = self.quesetionModel.content;
    CGFloat titleHeight = [self.quesetionModel.title sizeWithFont:16 textSizeWidht:Screen_Width-25 textSizeHeight:CGFLOAT_MAX].height;
    [self.questionContentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleHeight);
    }];
    CGFloat contentHeight = [self.quesetionModel.content sizeWithFont:13 textSizeWidht:Screen_Width-28 textSizeHeight:CGFLOAT_MAX].height;
      [self.questionDetailContentLab mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(contentHeight );
      }];
    [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(144+titleHeight+contentHeight);
    }];
}

#pragma mark --NetWorking
-(void)getQuestionDetailquest{
    [MBAlerManager showLoadingInView:self.view];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
       [dict setValue:self.questionId forKey:@"id"];
       [dict setValue:@(1) forKey:@"needIncrease"];
        
       [NewRequestClass requestQuestionDetail:dict success:^(id jsonData) {
           if (jsonData[@"data"][@"response"][@"row"]) {
                   self.quesetionModel = [QuestionListModel mj_objectWithKeyValues:jsonData[@"data"][@"response"][@"row"]];
               [self initData];
               [self getAnswerListquest];
            }
       } failure:^(NSError *error) {
        ZB_Toast(@"请求失败");
       }];
}
-(void)getAnswerListquest{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
       [dict setValue:self.questionId forKey:@"ykQuestionId"];
       [dict setValue:@(1) forKey:@"needIncrease"];
        [dict setValue:@(self.pageNo) forKey:@"pageNo"];
        [dict setValue:@(10) forKey:@"pageSize"];
       [NewRequestClass requestGetAnswerList:dict success:^(id jsonData) {
           [self.tableview.mj_footer endRefreshing];
           [self.tableview.mj_header endRefreshing];
            [MBAlerManager hideAlert];
           if (jsonData[@"data"][@"response"][@"rows"]) {
               for (NSDictionary * dict in jsonData[@"data"][@"response"][@"rows"] ) {
                   AnswerListModel * model = [AnswerListModel mj_objectWithKeyValues:dict];
                   CGFloat height = [model.answerContent sizeWithFont:14 textSizeWidht:Screen_Width-24 textSizeHeight:CGFLOAT_MAX].height;
                   model.Cellheight = 100+height;
                   [self.dataArr addObject:model];
               }
               
            }
           if (self.dataArr.count == 0) {
               [self.tableview.mj_footer endRefreshingWithNoMoreData];
           }
           [self.tableview reloadData];
       } failure:^(NSError *error) {
           [MBAlerManager hideAlert];
        ZB_Toast(@"请求失败");
       }];
}

#pragma mark ====== DKSKeyboardDelegate ======
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [MBAlerManager showLoadingInView:self.view];
   NSMutableDictionary * dict = [NSMutableDictionary dictionary];
   [dict setValue:textStr forKey:@"answerContent"];
   [dict setValue:self.questionId forKey:@"ykQuestionId"];
   [NewRequestClass requestAddAnswer:dict success:^(id jsonData) {
       [MBAlerManager hideAlert];
       if ([jsonData[@"data"][@"response"][@"flag"]boolValue]) {
           ZB_Toast(@"解答成功");
           self.pageNo = 1;
           [self.tableview.mj_footer resetNoMoreData];
           [self.dataArr removeAllObjects];
           [self getAnswerListquest];
       }else{
           ZB_Toast([jsonData[@"messages"][0]message]);
       }
   } failure:^(NSError *error) {
    ZB_Toast(@"解答发送失败");
   }];
}

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
   
   
}
#pragma -mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerListModel * model = self.dataArr[indexPath.row];
    return model.Cellheight;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QAContactTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QAContactTableViewCell"];
    AnswerListModel * model = self.dataArr[indexPath.row];
    cell.model = model;
    MJWeakSelf;
    cell.deleteBlock = ^{
            [weakSelf answerDelete:model withIndex:indexPath];
    };
    cell.praiseBlock = ^(BOOL isPraise) {
        if (isPraise) {
            [weakSelf answerCancelPraise:model withIndex:indexPath];
        }else{
            [weakSelf answerPraise:model withIndex:indexPath];
        }
    };
    return cell;
}

-(void)answerDelete:( AnswerListModel*)model withIndex:(NSIndexPath *)index{
    MJWeakSelf;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
         [dict setValue:model.answerId forKey:@"id"];
  [NewRequestClass requestDeleteAnswer:dict success:^(id jsonData){
     if ([jsonData[@"data"][@"response"][@"flag"]boolValue]) {
         ZB_Toast(@"删除发言成功");
         [weakSelf.dataArr removeObject:model];
         [weakSelf.tableview deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
             [weakSelf.tableview reloadData];
        } failure:^(NSError *error) {
          ZB_Toast(@"请求失败");
    }];
    
}

-(void)answerPraise:(AnswerListModel*)model withIndex:(NSIndexPath *)index{
    MJWeakSelf;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
         [dict setValue:model.answerId forKey:@"ykQuestionAnswerId"];
  [NewRequestClass requestPraiseAnswer:dict success:^(id jsonData){
     if ([jsonData[@"data"][@"response"][@"flag"]boolValue]) {
         model.praiseNum +=1;
         model.isPraised = YES;
         [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        
            }
      } failure:^(NSError *error) {
          ZB_Toast(@"请求失败");
    }];
    
}
-(void)answerCancelPraise:(AnswerListModel*)model withIndex:(NSIndexPath *)index{
    MJWeakSelf;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
         [dict setValue:model.answerId forKey:@"ykQuestionAnswerId"];
  [NewRequestClass requestPraiseCancel:dict success:^(id jsonData){
     if ([jsonData[@"data"][@"response"][@"flag"]boolValue]) {
         model.praiseNum -=1;
         model.isPraised = NO;
         [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
      } failure:^(NSError *error) {
          ZB_Toast(@"请求失败");
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}
#pragma mark ====== 点击UITableView ======
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //收回键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
        _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableview registerNib:[UINib nibWithNibName:@"QAContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"QAContactTableViewCell"];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.backgroundColor = kColorBarGrayBackground;
        [self.view addSubview:_tableview];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        tapGesture.delegate = self;
        [_tableview addGestureRecognizer:tapGesture];
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableview;
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
