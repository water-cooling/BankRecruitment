//
//  NoteTableViewCell.h
//  BankRecruitment
//
//  Created by xia jianqing on 17/4/22.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* AnalysisTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* AnalysisLabel;
@property (nonatomic, strong) IBOutlet UIButton* modifyNoteButton;

- (CGFloat)getHeightNoteTableCellByString:(NSString *)string;
@end
