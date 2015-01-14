//
//  InterfaceController.m
//  WatchKitTutorial WatchKit Extension
//
//  Created by Bowie Xu on 15/1/14.
//  Copyright (c) 2015年 CoconutIsland. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _buttonTitles = [NSArray arrayWithObjects:@"From Watch App", @"From Extension", @"From iOS App",nil];
    // Configure interface objects here.
    _titleIndex = 0;
    [self SetButtonTitle:_titleIndex];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void) ShowPicFromWatchKitApp
{
    [_watchImage setImageNamed:@"AppleImage.png"];
}

- (void) ShowPicFromExtension
{
    UIImage* image = [UIImage imageNamed:@"AppleRainbow.png"];
    [_watchImage setImage:image];
}

- (void) ShowPicFromiOSApp
{
    [self StopRequestAnimationData];
    
    _AnimationPics = [NSMutableDictionary dictionaryWithCapacity:MAXKEYS];//double buffer
    
    if (_AnimationTimer == nil) {
        [self RequestData:0];
    }
}

- (void) StopRequestAnimationData
{
    if (_AnimationPics != nil) {
        [_AnimationPics removeAllObjects];
        _AnimationPics = nil;
    }
    
    if (_AnimationTimer != nil) {
        [_AnimationTimer invalidate];
        _AnimationTimer = nil;
    }
    
    _PicArrayIndex = 0;
    _AnimationIndex = 0;
    
}

- (void) SetButtonTitle:(int)titleIndex
{
    [_watchButton setTitle:[_buttonTitles objectAtIndex:titleIndex]];
}

- (void) IncreaseIndex
{
    _titleIndex++;
    _titleIndex %= [_buttonTitles count];
}


- (IBAction)WatchButtonClicked {
    [self StopRequestAnimationData];
    [_watchImage setImage:nil];
    switch (_titleIndex) {
        case 0:
            [self ShowPicFromWatchKitApp];
            break;
        case 1:
            [self ShowPicFromExtension];
            break;
        case 2:
            [self ShowPicFromiOSApp];
            break;
        default:
            break;
    }
    
    [self IncreaseIndex];
    [self SetButtonTitle:_titleIndex];
}

-(void) _RequestData:(NSNumber*) nindex {
    //NSData* indexdata = [NSData dataWithBytes:&_AnimationIndex length:sizeof(_AnimationIndex)];
    //NSDictionary *request = [NSDictionary dictionaryWithObject:indexdata forKey:@"request"];
    int index = [nindex intValue];
    if (index>=MAXKEYS || index<0) {
        return;
    }
    
    NSDictionary *request = @{@"request":@"PIC"};
    NSString* key = [NSString stringWithFormat:@"%d", index];
    
    [_AnimationPics removeObjectForKey:key];
    
    [InterfaceController openParentApplication:request reply:^(NSDictionary *replyInfo, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
            [_AnimationPics removeObjectForKey:key];
        } else {
            NSData* data = [replyInfo objectForKey:@"PIC"];
            NSArray* picarray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_AnimationPics setObject:picarray forKey:key];
            
            //start animation
            if (_AnimationTimer == nil) {
                _AnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(SetAnimationIndex) userInfo:nil repeats:YES];
            }
            
        }
    }];
    
}

-(void) RequestData:(int) index {
    [NSThread detachNewThreadSelector:@selector(_RequestData:) toTarget:self withObject:[NSNumber numberWithInt:index]];
    
}


-(void)SetAnimationIndex{
    NSString* key = [NSString stringWithFormat:@"%d", _PicArrayIndex];
    NSArray* array = [_AnimationPics objectForKey:key];
    if(array != nil)
    {
        if (_AnimationIndex == 0) {
            //request for next buffer
            int requestindex = (_PicArrayIndex+1)%MAXKEYS;
            [self RequestData:requestindex];
        }
        
        if (_AnimationIndex<[array count]) {
            [_watchImage setImageData:[array objectAtIndex:_AnimationIndex]];
        }
        
        _AnimationIndex++;
        if( _AnimationIndex == [array count] - 1)
        {
            //switch to next buffer
            _AnimationIndex = 0;
            _PicArrayIndex ++;
            _PicArrayIndex %= MAXKEYS;
        }
    }
}


@end



