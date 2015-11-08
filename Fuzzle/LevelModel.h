//
//  LevelModel.h
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelModel : NSObject

@property (nonatomic, readonly) NSUInteger level;
@property (nonatomic, readonly) NSUInteger blockCount;
@property (nonatomic, readonly) NSUInteger solutionCount;

+ (LevelModel*) modelWithLevel:(NSUInteger)level blocks:(NSUInteger)count;

- (instancetype) initWithLevel:(NSUInteger)level blocks:(NSUInteger)count;

- (BOOL) isSolution:(NSArray*)blocks;

- (NSString*) describeSolution:(NSArray*)blocks;

- (NSArray*) sortBlocks:(NSArray*)blocks;

- (CGRect) computeBounds:(NSArray*)blocks;

@end
