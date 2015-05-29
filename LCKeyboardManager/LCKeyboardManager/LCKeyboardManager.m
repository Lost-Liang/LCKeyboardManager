//
//  LCKeyboardManager.m
//  LCKeyboardManager
//
//  Created by liangxiechao on 15/5/29.
//  Copyright (c) 2015年 liangxiechao. All rights reserved.
//

#import "LCKeyboardManager.h"


@implementation LCKeyboardManager

+ (void)load
{
    [super load];
    
    [LCKeyboardManager sharedInstance];
}
+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    static LCKeyboardManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            //  Registering for keyboard notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
            
            //  Registering for textField notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        });
    }
    return self;
}

#pragma mark - UIKeyboad Notification methods
-(void)keyboardWillShow:(NSNotification*)aNotification{
    CGPoint center = [m_textField convertPoint:m_textField.center toView:nil];
    CGRect kbFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationBar *naviBar = controller.navigationController.navigationBar;
    CGFloat naviBarHeight = [naviBar isEqual:nil] ? 0 : naviBar.frame.size.height;
    CGFloat textfiledToBottomDis = controller.view.frame.size.height - center.y - m_textField.frame.size.height/2 - naviBarHeight;
    if (textfiledToBottomDis < kbFrame.size.height + 20) {//textFiled margin 20 ptx to keyboad
        m_moveDis = kbFrame.size.height + 20 - textfiledToBottomDis;
        keyWindow.center = CGPointMake(keyWindow.center.x, keyWindow.center.y - m_moveDis);
        m_isMove = YES;
    }

}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    if (m_isMove) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.center = CGPointMake(keyWindow.center.x, keyWindow.center.y + m_moveDis);
    }
}

- (void)keyboardDidHide:(NSNotification*)aNotification{

}

#pragma mark - UITextFieldView Delegate methods
-(void)textFieldViewDidBeginEditing:(NSNotification*)notification{
    m_textField = notification.object;
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];

    [topView setItems:buttonsArray];
    
    [m_textField setInputAccessoryView:topView];
}
-(void)textFieldViewDidEndEditing:(NSNotification*)notification{
    
}

#pragma mark - accessoryView delegate
- (void)dismissKeyBoard{
    [m_textField resignFirstResponder];
}
@end
