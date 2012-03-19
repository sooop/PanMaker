//
//  SettingController.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 3. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"

const NSString *kSavingPathKey = @"SavingPath";
const NSString *kFileNameKey = @"FileName";
const NSString *kIndexNumberKey = @"IndexKey";


@interface  SettingController()
@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, copy) NSString *prefFilename;
@end

@implementation SettingController
@synthesize settings = _settings;
@synthesize fileName = _fileName, indexKey = _indexKey, savingPath = _savingPath;
@synthesize prefFilename = _prefFilename;

-(NSDictionary *)settings
{
    if(!_settings) {
        _settings = [NSDictionary dictionaryWithContentsOfFile:self.prefFilename];
    }
    return _settings;
}

-(NSString *)fileName
{
    return [self.settings objectForKey:(NSString*)kFileNameKey];
}

-(NSString *)savingPath
{
    return [self.settings objectForKey:(NSString*)kSavingPathKey];
}

-(NSNumber *)indexKey
{
    return [self.settings objectForKey:(NSString*)kIndexNumberKey];
}

-(void)setFileName:(NSString *)fileName
{
    if(_fileName != fileName) {
        [self.settings setValue:fileName forKey:(NSString *)kFileNameKey];
        [self saveSettings];
    }
}

-(void)setSavingPath:(NSString *)savingPath
{
    if(_savingPath != savingPath) {
        [self.settings setValue:savingPath forKey:(NSString *)kSavingPathKey];
        [self saveSettings];
    }
}

-(void)setIndexKey:(NSNumber *)indexKey
{
    if(_indexKey.intValue != indexKey.intValue) {
        [self.settings setValue:indexKey forKey:(NSString *)kIndexNumberKey];
        [self saveSettings];
    }
}

-(NSString *)prefFilename
{
    if(!_prefFilename) {
        _prefFilename = [[NSBundle mainBundle] pathForResource:@"prep" ofType:@"plist"];
    }
    return _prefFilename;
}


-(void)refreshSetting
{
    self.settings = [NSDictionary dictionaryWithContentsOfFile:self.prefFilename];

}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        [self refreshSetting];
    }
    
    return self;
}

-(void)saveSettings
{
    [self.settings setValue:self.fileName forKey:(NSString*)kFileNameKey];
    [self.settings setValue:self.indexKey forKey:(NSString*)kIndexNumberKey];
    [self.settings setValue:self.savingPath forKey:(NSString*)kSavingPathKey];
    [self.settings writeToFile:self.prefFilename atomically:YES];
    
}

-(void)increaseIndexKey
{
    self.indexKey = [NSNumber numberWithInt:(self.indexKey.intValue+1)];
}

+(SettingController*)defaultController {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

@end
