//
//  SettingController.h
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 3. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kSavingPathKey;
extern const NSString *kFileNameKey;
extern const NSString *kIndexNumberKey;

@interface SettingController : NSObject
@property (nonatomic, strong) NSNumber *indexKey;
@property (nonatomic, strong) NSString *savingPath;
@property (nonatomic, strong) NSString *fileName;
+(SettingController*)defaultController;
-(void)refreshSetting;
-(void)saveSettings;
-(void)increaseIndexKey;
@end
