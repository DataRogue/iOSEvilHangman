//
//  MainViewController.h
//  EvilHangman
//
//  Created by Lab User on 12/19/13.
//  Copyright (c) 2013 DmitriRoujan. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;


@end
