//
//  BlockView.h
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockView;

@protocol BlockViewDelegate <NSObject>

- (BOOL) blockView:(BlockView*)view snappedToGridPosition:(CGPoint)point;

@end

@interface BlockView : UIView

@property (nonatomic, weak) id<BlockViewDelegate> delegate;

- (void) snapToGrid;

@end
