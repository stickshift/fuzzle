//
//  ViewController.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "GameBoardViewController.h"
#import "LevelModel.h"
#import "CongratulationsViewController.h"

// Constants
#define TAG @"ViewController"
#define BLOCK_SIZE 44.0
#define PADDING_BETWEEN_CONTROLS 8.0
#define MAX_BLOCK_COUNT 5

@interface GameBoardViewController ()
{
    LevelModel* _model;
    NSUInteger _currentSolutionLabel;
    NSArray* _solutionLabels;
    NSMutableArray* _solutions;
    NSArray* _checkmarks;
}

@property (nonatomic, weak) IBOutlet UIView* gameBoardView;
@property (nonatomic, weak) IBOutlet UILabel* levelLabel;
@property (nonatomic, weak) IBOutlet UILabel* levelDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel* solution1Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution1Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* solution2Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution2Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* solution3Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution3Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* solution4Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution4Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* solution5Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution5Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* solution6Label;
@property (nonatomic, weak) IBOutlet UIImageView* solution6Checkmark;
@property (nonatomic, weak) IBOutlet UILabel* messageLabel;
@property (nonatomic, weak) IBOutlet UIButton* nextLevelButton;

- (IBAction) nextLevel:(id)sender;

@end

@implementation GameBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _solutionLabels = @[_solution1Label,
                        _solution2Label,
                        _solution3Label,
                        _solution4Label,
                        _solution5Label,
                        _solution6Label];
    _checkmarks = @[_solution1Checkmark,
                    _solution2Checkmark,
                    _solution3Checkmark,
                    _solution4Checkmark,
                    _solution5Checkmark,
                    _solution6Checkmark];
    
    _model = [LevelModel modelWithLevel:1 blocks:5];
    
    [self populateGameBoard];
}

- (IBAction) nextLevel:(id)sender
{
    if (_model.blockCount < MAX_BLOCK_COUNT)
    {
        _model = [LevelModel modelWithLevel:_model.level + 1 blocks:_model.blockCount + 1];
        [self populateGameBoard];
    }
}

/**
 * Resets game according to _model
 */
- (void) populateGameBoard
{
    // Start score timer on first level
    if (_model.level == 1)
    {
        [CongratulationsViewController startScoreTimer];
    }
    
    // Setup labels

    self.levelLabel.text = [NSString stringWithFormat:@"Level %lu", (unsigned long)_model.level];
    self.levelDescriptionLabel.text = [NSString stringWithFormat:@"Create %lu rectangles with %lu blocks", (unsigned long)_model.solutionCount, (unsigned long)_model.blockCount];

    _currentSolutionLabel = 0;
    _solutions = [NSMutableArray array];
    
    // Hide all solutions
    for (UIView* label in _solutionLabels)
    {
        label.hidden = YES;
    }
    
    // Setup solutions
    for (NSUInteger i = 0;i < _model.solutionCount;i++)
    {
        [_solutionLabels[i] setText:[NSString stringWithFormat:@"%u) ", i+1]];
        [_solutionLabels[i] setHidden:NO];
    }
    
    // Hide all checkmarks
    for (UIView* checkmark in _checkmarks)
    {
        checkmark.hidden = YES;
    }

    // Hide messageLabel
    self.messageLabel.hidden = YES;
    
    // Hide next level
    self.nextLevelButton.hidden = YES;
    
    // Add blocks
    
    // Clear old blocks
    [self.gameBoardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray* locations = [self generateRandomBlockLocations];
    
    for (NSUInteger i = 0; i < _model.blockCount; i++)
    {
        BlockView* blockView = [[BlockView alloc] initWithFrame:[locations[i] CGRectValue]];
        blockView.delegate = self;
        [blockView snapToGrid];
        [self.gameBoardView addSubview:blockView];
    }
}

- (NSArray*) generateRandomBlockLocations
{
    NSMutableArray* locations = [NSMutableArray array];
    
    CGFloat halfSizeOfView = BLOCK_SIZE / 2;
    CGSize insetSize = CGRectInset(self.gameBoardView.bounds, BLOCK_SIZE, BLOCK_SIZE).size;

    for (NSUInteger i = 0; i < _model.blockCount; i++)
    {
        CGFloat pointX = random() % ((int)insetSize.width) + halfSizeOfView;
        CGFloat pointY = random() % ((int)insetSize.height) + halfSizeOfView;
        
        // Make sure x,y doesn't overlap a previous location
        BOOL overlaps = NO;
        for (NSValue* v in locations)
        {
            CGRect r = [v CGRectValue];
            if (fabs(r.origin.x - pointX) < BLOCK_SIZE &&
                fabs(r.origin.y - pointY) < BLOCK_SIZE)
            {
                overlaps = YES;
                break;
            }
        }
        
        if (overlaps)
        {
            i--;
            continue;
        }
        
        [locations addObject:[NSValue valueWithCGRect:CGRectMake(pointX, pointY, BLOCK_SIZE, BLOCK_SIZE)]];
    }
    
    return locations;
}

- (BOOL) blockView:(BlockView*)blockView snappedToGridPosition:(CGPoint)point
{
    // Bail when initial block is placed
    if (self.gameBoardView.subviews.count < 2)
    {
        return YES;
    }
    
    // If block is outside the game board, reject the move
    if (point.x < 0 ||
        point.y < 0 ||
        point.x + BLOCK_SIZE > self.gameBoardView.bounds.size.width ||
        point.y + BLOCK_SIZE > self.gameBoardView.bounds.size.height)
    {
        return NO;
    }
    
    // If another block is already there, reject the move
    for (UIView* view in self.gameBoardView.subviews)
    {
        if (view != blockView && CGPointEqualToPoint(view.frame.origin, point))
        {
            return NO;
        }
    }
    
    NSMutableArray* blocks = [NSMutableArray arrayWithCapacity:self.gameBoardView.subviews.count];
    for (UIView* view in self.gameBoardView.subviews)
    {
        [blocks addObject:[NSValue valueWithCGRect:view.frame]];
    }
    
    if ([_model isSolution:blocks])
    {
        NSLog(@"%@ - Solution found!!!", TAG);
        [self acceptSolution:blocks];
    }
    
    return YES;
}

- (void) acceptSolution:(NSArray*)blocks
{
    NSString* description = [_model describeSolution:blocks];
    
    // Check if solution was already found
    if ([_solutions containsObject:description])
    {
        self.messageLabel.text = @"Try another shape.";
        self.messageLabel.hidden = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hideMessageLater:) userInfo:nil repeats:NO];
        
        return;
    }
    
    [_solutions addObject:description];
    
    // Add solution to list
    [_solutionLabels[_currentSolutionLabel] setText:[NSString stringWithFormat:@"%u) %@",
                                                                               _currentSolutionLabel+1,
                                                                              description]];
    [_checkmarks[_currentSolutionLabel] setHidden:NO];
    
    _currentSolutionLabel++;

    // Check if we're done with level
    if (_currentSolutionLabel == _model.solutionCount)
    {
        // Check if we're done with game
        if (_model.blockCount == MAX_BLOCK_COUNT)
        {
            [self performSegueWithIdentifier:@"congratulations" sender:self];
        }
        
        else
        {
            self.messageLabel.text = @"You found them all!";
            self.messageLabel.hidden = NO;
            
            self.nextLevelButton.hidden = NO;
        }
    }
}

- (void) hideMessageLater:(NSTimer*)timer
{
    self.messageLabel.hidden = YES;
}

@end
