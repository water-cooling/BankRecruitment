//
//  LdActionSheet.m
//  GroupV
//
//  Created by 陆瑞宁 on 14-3-25.
//  Copyright (c) 2014年 Lordar. All rights reserved.
//

#import "LdActionSheet.h"
#import "LdGlobalObj.h"

@implementation LdActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ldInit];
    }
    return self;
}

- (id) initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        if(otherButtonTitles != nil)
        {
            va_list args;
            va_start(args, otherButtonTitles);
            id arg = va_arg(args, id);
            while(arg)
            {
                [self addButtonWithTitle:(NSString*)arg];
                arg = va_arg(args, id);
            }
            va_end(args);
        }
        
        [self ldInit];
    }
    return self;
}

-(void)ldInit
{
    [LdGlobalObj sharedInstanse].actionSheet = self;
}

@end
