//
//  NoteViewController.m
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()
@property (nonatomic, strong) IBOutlet UITextView *textView;
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self drawViews];
    
    self.textView.text = self.NoteModel.Note;
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawViews
{
    self.title = @"编辑笔记";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 25.0f);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:0];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    if([LdGlobalObj sharedInstanse].isNightExamFlag)
    {
        self.view.backgroundColor = UIColorFromHex(0x2b3f5d);
        [backButton setImage:[UIImage imageNamed:@"night_btn_top_back"] forState:UIControlStateNormal];
        [saveButton setTitleColor:UIColorFromHex(0x7a8596) forState:UIControlStateNormal];
    }
    else
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [backButton setImage:[UIImage imageNamed:@"calendar_btn_arrow_left"] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonPressed
{
    if(!strIsNullOrEmpty(self.textView.text))
    {
        [self NetworkModifyNote:self.textView.text];
    }
    else
    {
        [self NetworkDeleteNote];
    }
}

#pragma -mark Network
- (void)NetworkModifyNote:(NSString *)note
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestPutNoteByID:self.examModel.ID Note:note Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

- (void)NetworkDeleteNote
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [LLRequestClass requestDeleteNoteByID:self.examModel.ID Success:^(id jsonData) {
        NSArray *contentArray=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", contentArray);
        if(contentArray.count > 0)
        {
            NSDictionary *contentDict = contentArray.firstObject;
            NSString *result = [contentDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        //ZB_Toast(@"失败");
    }];
}

@end
