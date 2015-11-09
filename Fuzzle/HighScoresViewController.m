//
//  HighScoresViewController.m
//  Fuzzle
//
//  Created by Andrew Young on 11/8/15.
//  Copyright © 2015 AndrewSomesYoung. All rights reserved.
//

#import "HighScoresViewController.h"

@interface HighScoresViewController ()
{
    NSArray* _timeLabels;
    NSArray* _nameLabels;
}

@property (nonatomic, weak) IBOutlet UILabel* firstPlaceTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* firstPlaceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* secondPlaceTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* secondPlaceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* thirdPlaceTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* thirdPlaceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* fourthPlaceTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* fourthPlaceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* fifthPlaceTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* fifthPlaceNameLabel;

@end

@implementation HighScoresViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _timeLabels = @[self.firstPlaceTimeLabel,
                    self.secondPlaceTimeLabel,
                    self.thirdPlaceTimeLabel,
                    self.fourthPlaceTimeLabel,
                    self.fifthPlaceTimeLabel];
    
    _nameLabels = @[self.firstPlaceNameLabel,
                    self.secondPlaceNameLabel,
                    self.thirdPlaceNameLabel,
                    self.fourthPlaceNameLabel,
                    self.fifthPlaceNameLabel];

    // Initialize all labels to empty
    for (UILabel* label in _timeLabels)
    {
        label.text = @"";
    }
    for (UILabel* label in _nameLabels)
    {
        label.text = @"";
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* highscores = [defaults objectForKey:@"highscores"];
    for (NSUInteger i = 0;i < highscores.count && i < 5;i++)
    {
        NSNumber* timeValue = [highscores[i] objectForKey:@"score"];
        long duration = [timeValue longValue];
        long minutes = duration / 60;
        long seconds = duration % 60;
        
        [_timeLabels[i] setText:[NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds]];

        NSString* name = [highscores[i] objectForKey:@"name"];
        [_nameLabels[i] setText:name];
    }
}

- (IBAction)letsPlay:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
