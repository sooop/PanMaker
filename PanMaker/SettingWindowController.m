//
//  SettingWindowController.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 3. 17..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SettingWindowController.h"
#import "SettingController.h"
@interface SettingWindowController ()
@property (weak) IBOutlet NSTextField *folderLabel;
@property (weak) IBOutlet NSTextField *filenameLabel;
@property (weak) IBOutlet NSTextField *indexLabel;
@end

@implementation SettingWindowController
@synthesize folderLabel;
@synthesize filenameLabel;
@synthesize indexLabel;
@synthesize delegate = _delegate;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)loadWindow
{
}

-(void)showWindow:(id)sender
{
    if(!self.window) {
        [NSBundle loadNibNamed:@"FolderSetting" owner:self];
    }
    else {
        [self.window makeKeyAndOrderFront:self];
    }
    
    SettingController *sc = [SettingController defaultController];
    self.indexLabel.objectValue = sc.indexKey.stringValue;
    self.filenameLabel.objectValue = sc.fileName;
    self.folderLabel.objectValue = sc.savingPath;
}

-(IBAction)filenameDidChage:(NSTextField*)sender
{
    [[SettingController defaultController] setFileName:[sender value]];
}
- (IBAction)indexResetPressed:(id)sender {
    [(SettingController*)[SettingController defaultController] setIndexKey:[NSNumber numberWithInt:0]];
    self.indexLabel.value = 0;
}
- (IBAction)indexDidChange:(NSTextField*)sender {
    [[SettingController defaultController] 
     setIndexKey:[NSNumber numberWithInt:[sender.value intValue]]];
}

- (IBAction)changeFolderPressed:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    
    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result) {
                          if(result == NSFileHandlingPanelOKButton ) {
                              NSString *savingPath = [[openPanel URL] path];
                              self.folderLabel.objectValue = savingPath;
                              [[SettingController defaultController] setSavingPath:savingPath];
                          }
                      }];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

}


@end
