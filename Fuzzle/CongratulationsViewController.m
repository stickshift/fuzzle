//
//  CongratulationsViewController.m
//  Fuzzle
//
//  Created by Andrew Young on 11/8/15.
//  Copyright © 2015 AndrewSomesYoung. All rights reserved.
//

#import "CongratulationsViewController.h"

// Constants
#define TAG @"CongratulationsViewController"

// Globals
static long startTime;

@interface CongratulationsViewController()
{
    long _score;
}

@property (nonatomic, weak) IBOutlet UITextField* nameField;

- (IBAction) saveHighScore:(id)sender;

@end

@implementation CongratulationsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.backgroundColor = [UIColor whiteColor];
    
    _score = time(NULL) - startTime;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) keyboardWillShow:(NSNotification*)notification
{
    NSLog(@"%@ - Showing keyboard", TAG);
    
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    
    CGRect frame = self.view.frame;
    frame.origin.y -= keyboardFrame.size.height;
    self.view.frame = frame;
}

- (void) keyboardWillHide:(NSNotification*)notification
{
    NSLog(@"%@ - Hiding keyboard", TAG);
    
    NSValue* keyboardFrameValue = notification.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    
    CGRect frame = self.view.frame;
    frame.origin.y += keyboardFrame.size.height;
    self.view.frame = frame;
}

+ (void) startScoreTimer
{
    startTime = time(NULL);
}

+ (long) currentTime
{
    return time(NULL) - startTime;
}

- (IBAction) saveHighScore:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray* highscores = [NSMutableArray array];
    NSArray* previousScores = [defaults arrayForKey:@"highscores"];
    if (previousScores)
    {
        [highscores addObjectsFromArray:previousScores];
    }

    NSLog(@"%@ - Saving high score of %ld for %@", TAG, _score, self.nameField.text);
    
    // Add new highscore row
    [highscores addObject:@{ @"name" : self.nameField.text,
                             @"score" : @(_score)}];
    
    // Sort by time, low score wins
    [highscores sortUsingComparator:^(id a, id b) {
        long scoreA = [[a objectForKey:@"score"] longValue];
        long scoreB = [[b objectForKey:@"score"] longValue];

        if (scoreA < scoreB)
        {
            return NSOrderedAscending;
        }

        if (scoreA > scoreB)
        {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    // Truncate to top 5
    NSArray* finalScores = highscores;
    if (highscores.count > 5)
    {
        finalScores = [highscores subarrayWithRange:NSMakeRange(0, 5)];
    }
    
    [defaults setObject:finalScores forKey:@"highscores"];
    
    // Pop back to the parent
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
