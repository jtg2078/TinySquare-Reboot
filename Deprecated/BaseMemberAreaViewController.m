//
//  BaseMemberAreaViewController.m
//  asoapp
//
//  Created by wyde on 12/10/31.
//
//

#import "BaseMemberAreaViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "SidebarViewController.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationController+Customize.h"



@interface BaseMemberAreaViewController ()<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseMemberAreaViewController
@synthesize leftSelectedIndexPath;
@synthesize leftSidebarViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.revealSidebarDelegate=self;
    
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconMembership2
                                                                                              iconPlacement:CustomizeButtonIconPlacementRight
                                                                                                     target:self
                                                                                                     action:@selector(revealRightSidebar:)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    
    [self.navigationController setRevealedState:JTRevealedStateNo];
    
    //modify over here
    
    BaseMemberAreaViewController *controller = [[BaseMemberAreaViewController alloc] init];
    controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    controller.title = (NSString *)object;
    controller.leftSidebarViewController  = sidebarViewController;
    controller.leftSelectedIndexPath      = indexPath;
    //controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
    sidebarViewController.sidebarDelegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:[self setupOptionViewController]] animated:NO];
   

    

}

-setupOptionViewController
{
    BaseMemberAreaViewController *hpmvc = [[BaseMemberAreaViewController alloc] init];
    //hpmvc.managedObjectContext = self.managedObjectContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hpmvc];
    nav.delegate = self;
    [nav setUpCustomizeAppearence];
    [hpmvc release];
    return [nav autorelease];
}

- (void)revealRightSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

- (UIView *)viewForRightSidebar {
    
    
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        //controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    
    
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
    
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view
    /*
     CGRect viewFrame = self.navigationController.applicationViewFrame;
     UITableView *view = self.rightSidebarView;
     if ( ! view) {
     view = self.rightSidebarView = [[UITableView alloc] initWithFrame:CGRectZero];
     view.dataSource = self;
     view.delegate   = self;
     }
     view.frame = CGRectMake(self.navigationController.view.frame.size.width - 270, viewFrame.origin.y, 270, viewFrame.size.height);
     view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
     return view;
     */
}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}


@end
