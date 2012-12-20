//
//  ChangeMemeberPasswordViewController.m
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import "ChangeMemeberPasswordViewController.h"

@interface ChangeMemeberPasswordViewController ()

@end

@implementation ChangeMemeberPasswordViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myScrollView release];
    [_myContentView release];
    [_oldPwdTextField release];
    [_againPwdTextField release];
    [_savePwdButton release];
    [_pwdNewTextField release];
    [super dealloc];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set the content view
    CGSize contentSize = self.myContentView.frame.size;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [self setOldPwdTextField:nil];
    [self setAgainPwdTextField:nil];
    [self setSavePwdButton:nil];
    [self setPwdNewTextField:nil];
    [super viewDidUnload];
}

#pragma mark - user interaction

- (IBAction)savePwdButtonPressed:(id)sender
{
    
}
@end
