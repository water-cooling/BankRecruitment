//
//  ChangePassedViewController.h
//  Bzisland
//
//  Created by xiajianqing  on 15/4/11.
//  Copyright (c) 2015年 cstor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassedViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *prePassedTextField;
@property (nonatomic, retain) IBOutlet UITextField *NewPassedTextField;
@property (nonatomic, retain) IBOutlet UITextField *reTryPassedTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
