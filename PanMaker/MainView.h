//
//  MainView.h
//  PanMaker
//
//  Created by BONGSOO KWON on 12. 2. 27..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DragDesinationViewDelegate <NSObject>
@optional
-(void)queueImageURL:(NSURL*)imageURL;
@end

@interface MainView : NSView
@property (weak, nonatomic) IBOutlet id<DragDesinationViewDelegate> delegate;
@end
