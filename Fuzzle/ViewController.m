//
//  ViewController.m
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import "ViewController.h"
#import "LevelModel.h"

// Constants
#define TAG @"ViewController"
#define BLOCK_SIZE 44.0
#define PADDING_BETWEEN_CONTROLS 8.0
#define MAX_BLOCK_COUNT 16

@interface ViewController ()
{
    LevelModel* _model;
    NSUInteger _currentSolution;
    NSArray* _solutions;
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
@property (nonatomic, weak) IBOutlet UILabel* youFoundThemLabel;
@property (nonatomic, weak) IBOutlet UIButton* nextLevelButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _solutions = @[_solution1Label,
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

- (void) populateGameBoard
{
    // Setup labels

    self.levelLabel.text = [NSString stringWithFormat:@"Level %lu", (unsigned long)_model.level];
    self.levelDescriptionLabel.text = [NSString stringWithFormat:@"Create %lu rectangles with %lu blocks", (unsigned long)_model.solutionCount, (unsigned long)_model.blockCount];

    _currentSolution = 0;

    // Hide all solutions
    for (UIView* solution in _solutions)
    {
        solution.hidden = YES;
    }
    
    // Setup solutions
    for (NSUInteger i = 0;i < _model.solutionCount;i++)
    {
        [_solutions[i] setText:[NSString stringWithFormat:@"%u) ", i+1]];
        [_solutions[i] setHidden:NO];
    }
    
    // Hide all checkmarks
    for (UIView* checkmark in _checkmarks)
    {
        checkmark.hidden = YES;
    }

    // Hide youFoundThem
    self.youFoundThemLabel.hidden = YES;
    
    // Hide next level
    self.nextLevelButton.hidden = YES;
    
    // Add blocks
    
    [self.gameBoardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat halfSizeOfView = BLOCK_SIZE / 2;
    CGSize insetSize = CGRectInset(self.gameBoardView.bounds, BLOCK_SIZE, BLOCK_SIZE).size;
    
    for (NSUInteger i = 0; i < _model.blockCount; i++)
    {
        CGFloat pointX = random() % ((int)insetSize.width) + halfSizeOfView;
        CGFloat pointY = random() % ((int)insetSize.height) + halfSizeOfView;
        
        BlockView* blockView = [[BlockView alloc] initWithFrame: CGRectMake(pointX, pointY, BLOCK_SIZE, BLOCK_SIZE)];
        [blockView snapToGrid];
        blockView.delegate = self;
        [self.gameBoardView addSubview:blockView];
    }
}

- (void) blockView:(BlockView*)view snappedToGridPosition:(CGPoint)point
{
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
}

- (void) acceptSolution:(NSArray*)blocks
{
    [_solutions[_currentSolution] setText:[NSString stringWithFormat:@"%u) %@", _currentSolution+1, [_model describeSolution:blocks]]];
    [_checkmarks[_currentSolution] setHidden:NO];
    
    _currentSolution++;
    
    if (_currentSolution == _model.solutionCount)
    {
        self.youFoundThemLabel.hidden = NO;
        self.nextLevelButton.hidden = NO;
    }
}

@end
