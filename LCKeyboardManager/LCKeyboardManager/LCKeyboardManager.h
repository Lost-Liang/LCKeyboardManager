//
//  LCKeyboardManager.h
//  LCKeyboardManager
//
//  Created by liangxiechao on 15/5/29.
//  Copyright (c) 2015年 liangxiechao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCKeyboardManager : NSObject
{
    UITextField *m_textField;
    CGFloat m_moveDis;//移动距离
    BOOL m_isMove;
}

@end
