//
//  FlipsideViewController.m
//  EvilHangman
//
//  Created by Lab User on 12/19/13.
//  Copyright (c) 2013 DmitriRoujan. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()
@property (weak, nonatomic) IBOutlet UISlider *sliderTries;
@property (weak, nonatomic) IBOutlet UISlider *sliderSize;
@property (weak, nonatomic) IBOutlet UILabel *labelSize;
@property (weak, nonatomic) IBOutlet UILabel *labelTries;

@end



@implementation FlipsideViewController
NSUserDefaults *userDefaults;



- (IBAction)numberOfTries:(UISlider *)sender {
    _labelTries.text = [[NSNumber numberWithFloat: roundf(_sliderTries.value)] stringValue];
    NSInteger num = [[NSNumber numberWithFloat: roundf(_sliderTries.value)] integerValue];
    [userDefaults setInteger:num forKey:@"tries"];
}
- (IBAction)wordSize:(id)sender {
    _labelSize.text = [[NSNumber numberWithFloat: roundf(_sliderSize.value)] stringValue];
    NSInteger num = [[NSNumber numberWithFloat: roundf(_sliderSize.value)] integerValue];
    [userDefaults setInteger:num forKey:@"size"];
    
}

//Find largest world size in list
-(void) setMaxNumberOfTires
{
    
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:file];
    NSInteger i= 0;
    for (NSString* string in array)
    {
        if(string.length>i)
        {
            i = string.length;
        }
        
    }
    _sliderSize.maximumValue=i;
    NSLog(@"%f", _sliderSize.maximumValue);
}

-(void) loadSettings
{
    _sliderSize.value = [userDefaults integerForKey:@"size"];
    _sliderTries.value = [userDefaults integerForKey:@"tries"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self loadSettings];
    _labelSize.text = [[NSNumber numberWithFloat: roundf(_sliderSize.value)] stringValue];
    _labelTries.text = [[NSNumber numberWithFloat: roundf(_sliderTries.value)] stringValue];
    [self setMaxNumberOfTires];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
