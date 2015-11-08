//
//  LevelModel.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "LevelModel.h"

@implementation LevelModel

+ (LevelModel*) modelWithLevel:(NSUInteger)level blocks:(NSUInteger)count
{
    return [[LevelModel alloc] initWithLevel:level blocks:count];
}

- (instancetype) initWithLevel:(NSUInteger)level blocks:(NSUInteger)count
{
    self = [super init];
    if (self)
    {
        _level = level;
        _blockCount = count;
    }
    return self;
}

- (NSUInteger) solutionCount
{
    switch (_blockCount)
    {
        case 0:
            return 0;
        case 1:
            return 1; // 1x1
        case 2:
            return 2; // 2x1,1x2
        case 3:
            return 2; // 3x1,1x3
        case 4:
            return 3; // 4x1,2x2,1x4
        case 5:
            return 2; // 5x1,1x5
        case 6:
            return 4; // 6x1,3x2,2x3,1x6
        case 7:
            return 2; // 7x1,1x7
        case 8:
            return 4; // 8x1,4x2,2x4,1x8
        case 9:
            return 3; // 9x1,3x3,1x9
        case 10:
            return 4; // 10x1,5x2,2x5,1x10
        case 11:
            return 2; // 11x1,1x11
        case 12:
            return 6; // 12x1,6x2,4x3,3x4,2x6,1x12
        case 13:
            return 2; // 13x1,1x13
        case 14:
            return 4; // 14x1,7x2,2x7,1x14
        case 15:
            return 4; // 15x1,5x3,3x5,1x15
        case 16:
            return 5; // 16x1,8x2,4x4,2x8,1x16
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:[NSString stringWithFormat:@"Unexpected blockCount %u", _blockCount]
                                         userInfo:nil];
    }
    return 0;
}

- (NSArray*) sortBlocks:(NSArray*)b
{
    // Make a mutable copy
    NSMutableArray* blocks = [NSMutableArray arrayWithArray:b];
    
    // Sort first by y, then by x
    [blocks sortUsingComparator:^(id block1, id block2) {
        
        CGRect frame1 = [block1 CGRectValue];
        CGRect frame2 = [block2 CGRectValue];
        
        // First by y
        if (frame1.origin.y < frame2.origin.y)
        {
            return NSOrderedAscending;
        }
        if (frame1.origin.y > frame2.origin.y)
        {
            return NSOrderedDescending;
        }
        
        // Then by x
        if (frame1.origin.x < frame2.origin.x)
        {
            return NSOrderedAscending;
        }
        if (frame1.origin.x > frame2.origin.x)
        {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    return blocks;
}

- (CGRect) computeBounds:(NSArray*)blocks
{
    CGRect topLeftFrame = [blocks[0] CGRectValue];
    CGRect bottomRightFrame = [blocks[blocks.count - 1] CGRectValue];
    CGRect bounds = CGRectMake(topLeftFrame.origin.x,
                               topLeftFrame.origin.y,
                               bottomRightFrame.origin.x + bottomRightFrame.size.width - topLeftFrame.origin.x,
                               bottomRightFrame.origin.y + bottomRightFrame.size.height - topLeftFrame.origin.y);
    return bounds;
}

- (BOOL) isSolution:(NSArray*)b
{
    NSArray* blocks = [self sortBlocks:b];
    CGRect bounds = [self computeBounds:blocks];
    
    // Verify bounds area matches number of blocks
    if (bounds.size.width / 44 * bounds.size.height / 44 != blocks.count)
    {
        return NO;
    }
    
    // Verify all blocks are within bounds
    for (NSValue* v in blocks)
    {
        CGRect r = [v CGRectValue];
        
        if (r.origin.x < bounds.origin.x ||
            r.origin.x > bounds.origin.x + bounds.size.width ||
            r.origin.x + r.size.width > bounds.origin.x + bounds.size.width)
        {
            return NO;
        }
        
        if (r.origin.y < bounds.origin.y ||
            r.origin.y > bounds.origin.y + bounds.size.height ||
            r.origin.y + r.size.height > bounds.origin.y + bounds.size.height)
        {
            return NO;
        }
    }
    
    // Verify all blocks are next to eachother
    for (NSUInteger i = 1;i < blocks.count;i++)
    {
        CGRect previous = [blocks[i-1] CGRectValue];
        CGRect current = [blocks[i] CGRectValue];
        
        // Verify x is either on left side of bounds or next to the previous block
        if (current.origin.x != bounds.origin.x && current.origin.x != previous.origin.x + previous.size.width)
        {
            return NO;
        }
        
        // Verify y is either the same as previous or one block below it
        if (current.origin.y != previous.origin.y && current.origin.y != previous.origin.y + previous.size.height)
        {
            return NO;
        }
    }
    
    // Verify all rows are complete
    for (NSUInteger i = 1;i < blocks.count;i++)
    {
        CGRect previous = [blocks[i-1] CGRectValue];
        CGRect current = [blocks[i] CGRectValue];
        
        // Make sure last block on a row reaches end of row
        if (current.origin.y != previous.origin.y && previous.origin.x + previous.size.width != bounds.origin.x + bounds.size.width)
        {
            return NO;
        }
    }
    
    return YES;
}

- (NSString*) describeSolution:(NSArray*)b
{
    NSArray* blocks = [self sortBlocks:b];
    CGRect bounds = [self computeBounds:blocks];

    NSUInteger width = bounds.size.width / [blocks[0] CGRectValue].size.width;
    NSUInteger height = bounds.size.height / [blocks[0] CGRectValue].size.height;
    
    return [NSString stringWithFormat:@"%ux%u", width, height];
}

@end
