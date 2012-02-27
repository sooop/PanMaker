//
//  AppController.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 2. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
@interface AppController() 
@property (weak) IBOutlet NSMatrix *directionSelect;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *mainView;
@end

@implementation AppController
@synthesize directionSelect;
@synthesize tableView;
@synthesize mainView;
- (IBAction)generateClicked:(id)sender {
}

-(void)awakeFromNib
{
    [self.mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSColorPboardType,NSFilenamesPboardType, nil]];
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"Entered");
    return NSDragOperationGeneric;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}


@end
