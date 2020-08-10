//
//  LdAlertView.m
//  GroupV
//
//  Created by 陆瑞宁 on 14-3-25.
//  Copyright (c) 2014年 Lordar. All rights reserved.
//

#import "LdAlertView.h"
#import "LdGlobalObj.h"

@implementation LdAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
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
    [LdGlobalObj sharedInstanse].alertView = self;
}

@end
