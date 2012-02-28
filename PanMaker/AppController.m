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
    double kRatioFactor;
}
@property (weak) IBOutlet NSMatrix *directionSelect;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *mainView;
@end

@implementation AppController
@synthesize directionSelect;
@synthesize tableView;
@synthesize mainView;

#define RESULT_IMAGE_WIDTH 640
#define RESULT_IMAGE_HEIGHT 480
#define PATH_TO_SAVE @"/Users/soooprmx/Desktop/result.png"



#pragma mark - utilities

-(float)getMaxWidth
{
    float result = 0;
    if (![imageList count]) {
        for(id aObj in imageList) {
            int width = [[aObj valueForKeyPath:@"size.width"] floatValue];
            if (width > result) result = width;
        }
    }
    return result;
}

-(float)getMaxHeight
{
    float result = 0;
    if (![imageList count]) {
        for(id aObj in imageList) {
            int width = [[aObj valueForKeyPath:@"size.height"] floatValue];
            if (width > result) result = width;
        }
    }
    return result;
}

-(float)getTotalHeight
{
    float result = 0;
    for (id aObj in imageList) {
        NSSize aSize = [(NSImage*)aObj size];
        float heightOfOneImage = 640 * aSize.height / aSize.width;
        result += heightOfOneImage;
    }
    return result;
}

-(void)makePanorama
{
    if (![imageURLList count]) return;
    
    // 세로방향으로 더함
    NSSize resultSize;
    resultSize.width = RESULT_IMAGE_WIDTH;
    resultSize.height = [self getTotalHeight];
    NSImage *resultImage = [[NSImage alloc] initWithSize:resultSize];
    NSPoint startPoint;
    NSSize startSize;
    startPoint.x = 0;
    startPoint.y = resultImage.size.height;
    startSize.width = 640;
    startSize.height = 0;
    
    [resultImage lockFocus];
    for (NSImage *anImage in imageList) {
        startSize.height = anImage.size.height * 640 / anImage.size.width;
        startPoint.y -= startSize.height;
        NSRect rectOfAnImage = NSMakeRect(startPoint.x, startPoint.y, startSize.width, startSize.height);
        [anImage drawInRect:rectOfAnImage fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    [resultImage unlockFocus];
    
//    NSImageView *aaa = [[NSImageView alloc] initWithFrame:self.mainView.frame];
//    aaa.image = resultImage;
//    [self.mainView addSubview:aaa];
    
    NSData *resultImageData = [resultImage TIFFRepresentation];
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:resultImageData];
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    resultImageData = [rep representationUsingType:NSPNGFileType properties:properties];
    [resultImageData writeToFile:PATH_TO_SAVE atomically:NO];
    
    resultImage = nil;
    resultImageData = nil;
    imageList = [NSMutableArray array];
    imageURLList = [NSMutableArray array];
    [self.tableView reloadData];
    
    
}


#pragma mark - IBActions

-(void)awakeFromNib
{
    [self.mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType,NSFilenamesPboardType, nil]];
    imageURLList = [NSMutableArray array];
    imageList = [NSMutableArray array];
    kRatioFactor = 0;
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

- (IBAction)generatePressed:(id)sender {
    [self makePanorama];
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


@end

