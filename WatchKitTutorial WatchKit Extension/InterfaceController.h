//
//  InterfaceController.h
//  WatchKitTutorial WatchKit Extension
//
//  Created by Bowie Xu on 15/1/14.
//  Copyright (c) 2015年 CoconutIsland. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

#define MAXKEYS     2

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceImage *watchImage;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *watchButton;

@property (strong, nonatomic) NSArray*    buttonTitles;
@property (assign, nonatomic) int       titleIndex;

@property (strong, nonatomic) NSMutableDictionary* AnimationPics;
@property (strong, nonatomic) NSTimer* AnimationTimer;
@property (assign, nonatomic) int PicArrayIndex;
@property (assign, nonatomic) int AnimationIndex;

- (IBAction)WatchButtonClicked;


@end
