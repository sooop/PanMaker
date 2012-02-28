//
//  MainView.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 2. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"

@implementation MainView
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    if([[pboard types] containsObject:NSURLPboardType]) return NSDragOperationGeneric;
    else return NSDragOperationNone;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSURL *imageURL = [NSURL URLFromPasteboard:pboard];
    [self.delegate queueImageURL:imageURL];
    NSLog(@"URL Dropped:%@",[imageURL path]);
    
    return YES;
}

@end
