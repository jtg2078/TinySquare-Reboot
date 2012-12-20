//
//  EditMemeberViewController.m
//  asoapp
//
//  Created by jason on 12/20/12.
//
//

#import "EditMemeberViewController.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"

@interface EditMemeberViewController ()

@end

@implementation EditMemeberViewController

#pragma mark - view lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myScrollView release];
    [_myContentView release];
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
    
    // Create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconMembership2
                                                                                              iconPlacement:CustomizeButtonIconPlacementRight
                                                                                                     target:self
                                                                                                     action:@selector(showMemberSidebar:)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    
    // setup the content view
    CGSize contentSize = self.myContentView.frame.size;
    contentSize.height += 164;
    self.myScrollView.contentSize = contentSize;
    [self.myScrollView addSubview:self.myContentView];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setMyContentView:nil];
    [super viewDidUnload];
}

#pragma mark - user interaction

- (void)showMemberSidebar:(id)sender
{
    if([self.viewDeckController isSideClosed:IIViewDeckRightSide])
        [self.viewDeckController openRightViewAnimated:YES];
    else
        [self.viewDeckController closeRightViewAnimated:YES];
}


@end
