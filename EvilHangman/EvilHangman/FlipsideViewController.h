//
//  FlipsideViewController.h
//  EvilHangman
//
//  Created by Lab User on 12/19/13.
//  Copyright (c) 2013 DmitriRoujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
