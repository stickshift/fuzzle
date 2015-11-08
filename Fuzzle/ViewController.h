//
//  ViewController.h
//  Fuzzle
//
//  Created by Andrew Young on 11/5/15.
//  Copyright (c) 2015 AndrewSomesYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockView.h"

@interface ViewController : UIViewController<BlockViewDelegate>

- (IBAction) nextLevel:(id)sender;

@end

