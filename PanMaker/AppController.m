//
//  AppController.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 2. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
@interface AppController() <NSTableViewDataSource>
{
    NSMutableArray *imageURLList;
    NSMutableArray *imageList;
}
@property (weak) IBOutlet NSMatrix *directionSelect;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *mainView;
@end

@implementation AppController
@synthesize directionSelect;
@synthesize tableView;
@synthesize mainView;


-(void)awakeFromNib
{
    [self.mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSColorPboardType,NSFilenamesPboardType, nil]];
    imageURLList = [NSMutableArray array];
    imageList = [NSMutableArray array];
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

#pragma mark - Main View Delegate
-(void)queueImageURL:(NSURL *)imageURL
{
    [imageURLList addObject:imageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    NSImage *anImage = [[NSImage alloc] initWithData:imageData];
    [imageList addObject:anImage];
    
    [self.tableView reloadData];
}

#pragma mark - table view data source
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [imageURLList count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSSize imageSize = [(NSImage*)[imageList objectAtIndex:row] size];
    if ([tableColumn.identifier isEqualToString:@"path"]) {
        return [[imageURLList objectAtIndex:row] path];
    }
    if( [tableColumn.identifier isEqualToString:@"height"]) {
        return [NSString stringWithFormat:@"%4.0f",imageSize.height];
    }
    if( [tableColumn.identifier isEqualToString:@"width"]) {
        return [NSString stringWithFormat:@"%4.0f",imageSize.width];
    }
    return @"";
}

-(void)makePanorama
{
    if (![imageURLList count]) return;
    NSImageView *anImageView = [[NSImageView alloc] initWithFrame:self.mainView.frame];
    anImageView.image = [imageList objectAtIndex:0];
    [self.mainView addSubview:anImageView];

}

- (IBAction)generatePressed:(id)sender {
    [self makePanorama];
}

@end
