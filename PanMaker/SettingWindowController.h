//
//  SettingWindowController.h
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 3. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol SettingDelegate <NSObject>
@optional
-(void)settingDidChange:(id)sender withInfo:(NSDictionary*)userInfo;
@end
@interface SettingWindowController : NSWindowController
@property (weak, nonatomic) id<SettingDelegate> delegate;
@end
