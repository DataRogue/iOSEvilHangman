//
//  MainViewController.m
//  EvilHangman
//
//  Created by Lab User on 12/19/13.
//  Copyright (c) 2013 DmitriRoujan. All rights reserved.
//

/*
 
 Okay s the data structyure should be fairly simple. By fairly simple I mean not very. I will create a dictionary that will hold all the equivalance classes
 as the keys. Inside associated with each will be an array of all the words that fit that equivalance class. The keys will have to be calculated for each word.
 */

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textBox;
@property (weak, nonatomic) IBOutlet UILabel *gameBoard;
@property (weak, nonatomic) IBOutlet UILabel *nPC;
@property (weak, nonatomic) IBOutlet UILabel *guesses;

@end

@implementation MainViewController


//Declare publics
NSUserDefaults *userDefaults;
NSMutableArray *fileArray;
NSNotificationCenter *notificationCenter;
NSInteger size;
NSInteger tries;
NSInteger guess;
NSMutableArray *guessedLetters;

bool gameOver = NO;

NSString *tempKey; //Very dirty method of doing this, but that's crappy foresight for ya

- (IBAction)newGame:(id)sender {
    _nPC.text = @"Try again, scrub.";
    [self viewDidLoad];
}

//Initialize and configure keyboard input
-(void) setupKeyboard
{
    notificationCenter=[NSNotificationCenter defaultCenter];
    if([_textBox canBecomeFirstResponder]){
        [_textBox becomeFirstResponder];
    }
    _textBox.autocorrectionType = UITextAutocorrectionTypeNo;
    [notificationCenter addObserver:self
                           selector:@selector (textFieldText:)
                               name:UITextFieldTextDidChangeNotification
                             object:_textBox];
}

//What gets called whenever a key is pressed
- (void) textFieldText:(NSNotification*)notification
{
    //Get content of text field
    UITextField* txt = (UITextField*)notification.object;
    NSString *textie = [txt.text lowercaseString];
  //  NSLog(@"%@", textie);
    unichar character = [txt.text characterAtIndex:0];
    if(![self sanitizePlayerStupidity:textie] && !gameOver)
    {
        
        [guessedLetters addObject:textie];
        NSDictionary *dictionary=[self delegateIntoDictionary:fileArray andChar:character];
        fileArray = [self delegateIntoArray:dictionary];
        [self updateLabel:tempKey andChar:textie];
    
        [self updateGuess];
        [self hasPlayerWon];
        [self hasPlayerLost];
    }
    else
    {
        _nPC.text = @"You can't do that, fool.";
    }
    //Clear input field
    txt.text = @"";
}

-(BOOL)sanitizePlayerStupidity:(NSString*)text
{
    BOOL playerStupid = NO;
    for (NSString *flarg in guessedLetters) {
        if([flarg isEqualToString:text])
        {
         //   NSLog(@"Repeat");
            playerStupid = YES;
        }
   
    }
    
    NSString *regex = @"[a-z]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [test evaluateWithObject:text];
    
    if (!result)
    {  //     NSLog(@"Invalid");
        playerStupid = YES;
}
    return playerStupid;
}


//Load label first time
-(void) initializeLabel
{

    NSMutableString *temp= [NSMutableString stringWithString:@""];
    for (NSInteger i = 0; i<size;i++)
    {
        [temp appendFormat:@" _"];
    }
    _gameBoard.text = temp;
    
}

-(void) updateLabel:(NSString*)key andChar:(NSString*)word
{
    
    
    //Loads current board state
    NSMutableString *current = [NSMutableString stringWithString: _gameBoard.text];
    //What we use for blank space
    unichar character = '_';
    //For every letter in the key
    for (NSInteger i = 0; i<key.length; i++)
    {
        //Check if it's not blank
        if ([key characterAtIndex:i]!=character)
        {
            //If it's not we replace the related spot in the game board with that letter
            NSRange temp = {(i*2)+1,1};
            NSMutableString *replace = [NSMutableString stringWithString:word];
            [current replaceCharactersInRange:temp withString:replace];
        }
    }
    //Then we update the gameboard
    _gameBoard.text = current;
}

-(BOOL) hasPlayerWon
{
    for (NSInteger i = 0; i<_gameBoard.text.length; i++)
    {
    if ([_gameBoard.text characterAtIndex:i]=='_') {
      //  NSLog(@"Char at index: %i",i);
        return NO;
    }
    }
    _nPC.text = @"No fair! You cheated!";
//    NSLog(@"Victor!");
    gameOver = YES;
    return YES;
}

-(BOOL) hasPlayerLost
{
    if (tries - guess == -1) {
        _nPC.text = @"Once again, you fail.";
 //       NSLog(@"You lose");
        gameOver = YES;
    }
    return NO;
}

-(void) updateGuess
{
    NSString *deguess = [NSString stringWithFormat:@"%i", tries-guess];
    _guesses.text = deguess;
  //  NSLog(@"%i",tries-guess);
    guess++;
}

//Load and return the list of words as an NSArray
-(void)loadPlist:(NSString*)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    fileArray = [NSArray arrayWithContentsOfFile:file];
}

//Filters out words based on size
-(NSMutableArray*) wordSizeFilter:(NSMutableArray*)array
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSString *string in array){
        if(string.length==size) [temp addObject:string];
    }
    return temp;
}

//Loads settings or setup default ones
-(void) loadSettings
{
    guess = 0;
    guessedLetters = [[NSMutableArray alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"size"] == nil)
    {
      //  NSLog(@"Loading defaults");
        NSString *temp = fileArray[0];
   //     NSLog(@"%@",temp);
        [userDefaults setInteger:temp.length forKey:@"size"];
        [userDefaults setInteger:4 forKey:@"tries"];
    }
    size =  [userDefaults integerForKey:@"size"];
    tries = [userDefaults integerForKey:@"tries"];
}

//Takes an array and creates a dictionary of equivalance classes
-(NSMutableDictionary*)delegateIntoDictionary:(NSArray*)array andChar:(unichar)character
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for(NSString* object in array)
    {
        NSString *blah = object.lowercaseString;
   //     NSLog(@"%@", blah);
        
        
        NSMutableString *dkey = [NSMutableString stringWithString:@""];
        
        for (NSInteger i = 0; i<blah.length; i++) {
            if ([blah characterAtIndex:i]==character) {
                [dkey appendString:[NSString stringWithCharacters:&character length:1]];
            }
            else
            {
                [dkey appendString:@"_"];
            }
        }
        //NSLog(@"%@",dkey);
        
        //Checks to see if the key already exists
        if([dictionary valueForKey:dkey] != nil) {
            NSMutableArray *arr = [dictionary objectForKey:dkey];
            [arr addObject:blah];
            [dictionary setObject:arr forKey:dkey];
          //  NSLog(@"Existing array detected it contains %@",arr);
        }
        else {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObject:blah];
            [dictionary setObject:arr forKey:dkey];
        }
        

    }
    return dictionary;
}

//Takes a dictionary of equivalance classes and provides the largest array
-(NSMutableArray*)delegateIntoArray:(NSDictionary*)dictionary
{
    NSMutableArray *winner;
    NSInteger winnerSize = 0;
    
    for (NSString* key in dictionary) {
        NSMutableArray *value = [dictionary objectForKey:key];
        NSInteger size = [value count];
        if (winnerSize<size || winner == nil) {
            winnerSize = size;
            winner = value;
            tempKey =key;
        }
    //    NSLog(@"%@ has %i", key, [value count]);
    }
    return winner;
}

//When the view loads
- (void)viewDidLoad
{
 //   NSLog(@"App launched");
    [super viewDidLoad];
    
    
    [self loadPlist:@"words"];
    [self loadSettings];
    [self initializeLabel];
    [self updateGuess];
    gameOver = NO;
    fileArray = [self wordSizeFilter:fileArray];
    
    [self setupKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)showInfo:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        if (!self.flipsidePopoverController) {
            FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
            controller.delegate = self;
            
            self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}





@end
