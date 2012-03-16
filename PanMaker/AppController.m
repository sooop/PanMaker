//
//  AppController.m
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 2. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

typedef enum{
    kPanoramaImageDirectionVertical = 0,
    kPanoramaImageDirectionHorizontal = 1
} compositedImageDirection;

@interface AppController() <NSTableViewDataSource>
{
    NSMutableArray *imageURLList;
    NSMutableArray *imageList;
    double kRatioFactor;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *mainView;
@property (nonatomic) float resultSize;
@property (nonatomic) compositedImageDirection panoramaDirection;
@property (nonatomic,strong) NSNumber *modeNumber;
@end

@implementation AppController
@synthesize tableView;
@synthesize mainView;
@synthesize panoramaDirection = _panoramaDirection, resultSize = _rulingSize;
@synthesize modeNumber = _modeNumber;

-(NSNumber*)modeNumber
{
    if(!_modeNumber) {
        _modeNumber = [NSNumber numberWithInt:0];
    }
    _modeNumber = [NSNumber numberWithInt:(int)self.panoramaDirection];
    return _modeNumber;
}

#define PATH_TO_SAVE @"/Users/soooprmx/Desktop/result.png"

-(NSString*)savePath
{
    NSString *result = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    result  = [result stringByAppendingPathComponent:@"result.png"];
    return result;
    
}



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
        float heightOfOneImage = self.resultSize * aSize.height / aSize.width;
        result += heightOfOneImage;
    }
    return result;
}

-(float)getTotalWidth
{
    float result = 0;
    for (id aObj in imageList) {
        NSSize aSize = [(NSImage*)aObj size];
        float widthOfOneImage = self.resultSize * aSize.width / aSize.height;
        result += widthOfOneImage;
    }
    return result;
}


-(void)makePanorama
{
    if (![imageURLList count]) return;
    
    NSSize resultSize;
    NSPoint startPoint;
    NSSize startSize;
    NSImage *resultImage;
    
    if(self.panoramaDirection == kPanoramaImageDirectionVertical) {
        // 세로방향으로 더함
        resultSize.width = self.resultSize;
        resultSize.height = [self getTotalHeight];
        
        resultImage = [[NSImage alloc] initWithSize:resultSize];

        startPoint.x = 0;
        startPoint.y = resultImage.size.height;
        startSize.width = self.resultSize;
        startSize.height = 0;
        
        [resultImage lockFocus];
        for (NSImage *anImage in imageList) {
            startSize.height = anImage.size.height * self.resultSize / anImage.size.width;
            startPoint.y -= startSize.height;
            NSRect rectOfAnImage = NSMakeRect(startPoint.x, startPoint.y, startSize.width, startSize.height);
            [anImage drawInRect:rectOfAnImage fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
        [resultImage unlockFocus]; 
        
    } 
    else {
        // 가로방향으로 이미지를 더함
        resultSize.height = self.resultSize;
        resultSize.width = [self getTotalWidth];
        
        resultImage = [[NSImage alloc] initWithSize:resultSize];
        
        startPoint.x = 0;
        startPoint.y = 0;
        startSize.width = 0;
        startSize.height = self.resultSize;
        
        [resultImage lockFocus];
        for (NSImage *anImage in imageList) {
            startSize.width = anImage.size.width * self.resultSize / anImage.size.height;
            NSRect rectOfAnImage = NSMakeRect(startPoint.x, startPoint.y, startSize.width, startSize.height);
            [anImage drawInRect:rectOfAnImage fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            startPoint.x += startSize.width;
        }
        [resultImage unlockFocus];
    }
    
    

    
    NSData *resultImageData = [resultImage TIFFRepresentation];
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:resultImageData];
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    
    resultImageData = [rep representationUsingType:NSPNGFileType properties:properties];
    
    BOOL success = [resultImageData writeToFile:[self savePath] atomically:NO];
    if(success) {
        resultImage = nil;
        resultImageData = nil;
        [imageList removeAllObjects];
        [imageURLList removeAllObjects];
        [self.tableView reloadData];        
    }
    
    
}


#pragma mark - IBActions

-(void)awakeFromNib
{
    [self.mainView registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType,NSFilenamesPboardType, nil]];
    imageURLList = [NSMutableArray array];
    imageList = [NSMutableArray array];
    kRatioFactor = 0;
    self.panoramaDirection = kPanoramaImageDirectionVertical;
    self.resultSize = 400;
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

