//
//  LevelModelTests.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LevelModel.h"

@interface LevelModelTests : XCTestCase @end
@implementation LevelModelTests

- (void)testSolutionCount
{
    XCTAssertEqual(0, [[LevelModel modelWithLevel:0 blocks:0] solutionCount]);
    XCTAssertEqual(1, [[LevelModel modelWithLevel:0 blocks:1] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:2] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:3] solutionCount]);
    XCTAssertEqual(3, [[LevelModel modelWithLevel:0 blocks:4] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:5] solutionCount]);
    XCTAssertEqual(4, [[LevelModel modelWithLevel:0 blocks:6] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:7] solutionCount]);
    XCTAssertEqual(4, [[LevelModel modelWithLevel:0 blocks:8] solutionCount]);
    XCTAssertEqual(3, [[LevelModel modelWithLevel:0 blocks:9] solutionCount]);
    XCTAssertEqual(4, [[LevelModel modelWithLevel:0 blocks:10] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:11] solutionCount]);
    XCTAssertEqual(6, [[LevelModel modelWithLevel:0 blocks:12] solutionCount]);
    XCTAssertEqual(2, [[LevelModel modelWithLevel:0 blocks:13] solutionCount]);
    XCTAssertEqual(4, [[LevelModel modelWithLevel:0 blocks:14] solutionCount]);
    XCTAssertEqual(4, [[LevelModel modelWithLevel:0 blocks:15] solutionCount]);
    XCTAssertEqual(5, [[LevelModel modelWithLevel:0 blocks:16] solutionCount]);
}

- (void) testIsCorrect
{
    LevelModel* model = [LevelModel modelWithLevel:1 blocks:6];
    CGFloat size = 44;
    NSMutableArray* blocks = [NSMutableArray arrayWithCapacity:6];
    
    // 6x1
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(2*size, 0, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(3*size, 0, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(4*size, 0, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(5*size, 0, size, size)];
    XCTAssert([model isSolution:blocks]);    
    
    // 1x6
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(0, 1*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(0, 2*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(0, 3*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(0, 4*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(0, 5*size, size, size)];
    XCTAssert([model isSolution:blocks]);
    
    // 3x2
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(2*size, 0*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(1*size, 1*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(2*size, 1*size, size, size)];
    XCTAssert([model isSolution:blocks]);
    
    // 2x3
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(1*size, 1*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(0*size, 2*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(1*size, 2*size, size, size)];
    XCTAssert([model isSolution:blocks]);
}

- (void) testIsNotCorrect
{
    LevelModel* model = [LevelModel modelWithLevel:1 blocks:6];
    CGFloat size = 44;
    NSMutableArray* blocks = [NSMutableArray arrayWithCapacity:6];
    
    // 5 in a row with one under neath
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(2*size, 0*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(3*size, 0*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(4*size, 0*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    XCTAssertFalse([model isSolution:blocks]);
    
    // 5 in a row with one under neath
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(2*size, 0*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(3*size, 0*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(4*size, 0*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(4*size, 1*size, size, size)];
    XCTAssertFalse([model isSolution:blocks]);
    
    // C
    model = [LevelModel modelWithLevel:1 blocks:5];
    blocks = [NSMutableArray arrayWithCapacity:5];
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(0*size, 2*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(1*size, 2*size, size, size)];
    XCTAssertFalse([model isSolution:blocks]);

    // Box dot
    model = [LevelModel modelWithLevel:1 blocks:5];
    blocks = [NSMutableArray arrayWithCapacity:5];
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(1*size, 1*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(2*size, 2*size, size, size)];
    XCTAssertFalse([model isSolution:blocks]);
    
    // A 3x3 donut with a hole
    model = [LevelModel modelWithLevel:1 blocks:8];
    blocks = [NSMutableArray arrayWithCapacity:8];
    blocks[0] = [NSValue valueWithCGRect:CGRectMake(0*size, 0*size, size, size)];
    blocks[1] = [NSValue valueWithCGRect:CGRectMake(1*size, 0*size, size, size)];
    blocks[2] = [NSValue valueWithCGRect:CGRectMake(2*size, 0*size, size, size)];
    blocks[3] = [NSValue valueWithCGRect:CGRectMake(0*size, 1*size, size, size)];
    blocks[4] = [NSValue valueWithCGRect:CGRectMake(2*size, 1*size, size, size)];
    blocks[5] = [NSValue valueWithCGRect:CGRectMake(0*size, 2*size, size, size)];
    blocks[6] = [NSValue valueWithCGRect:CGRectMake(1*size, 2*size, size, size)];
    blocks[7] = [NSValue valueWithCGRect:CGRectMake(2*size, 2*size, size, size)];
    XCTAssertFalse([model isSolution:blocks]);
}

@end
