//
//  BuyDetailViewController.m
//  asoapp
//
//  Created by wyde on 12/6/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "UINavigationController+Customize.h"
#import "ThemeManager.h"
#import "TmpCart.h"
#import "CartItemCell.h"
#import "ThemeManager.h"
#import "AppDelegate.h"
#import "TATabBarController.h"


#define TAB_IMAGE_NAME				@"ProductWindowTabIcon.png"

@interface BuyDetailViewController ()


@end

@implementation BuyDetailViewController
@synthesize productId;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    [super initWithStyle:style];
    if (self = [super initWithStyle:style]) 
	{
		self.title = NSLocalizedString(@"購買商品資訊", nil);
    }
    
	return self;

}

-(id) initwithItemId:(int)itemId
{
    self=[super init];
    if (self) {
        self.productId=itemId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TmpCart *tc=[TmpCart getProductIfExistWithProductId:[NSNumber numberWithInt:self.productId] inManagedObjectContext:managedObjectContext];
    myData = [[NSArray alloc] initWithObjects:@"品項",@"欲購數量" , @"附加描述", nil];
    myDataDescription=[[NSMutableArray alloc] initWithObjects:tc.productName,[NSString stringWithFormat:@"%@",tc.buyItemCount],@"", nil];
    //myDataDescription=[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",self.productId],@"", nil];
    [self setupNavigationBarButtons];
    ThemeManager *thememgr=[ThemeManager sharedInstance];
    self.view.backgroundColor=thememgr.productCellBgColor;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setupNavigationBarButtons
{
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Buy Item Count";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    cell.textLabel.text = (NSString*)[myData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=  (NSString*)[myDataDescription objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSNumber numberWithInt:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:1]] ) {
        
        UIActionSheet *actionsheet=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"確定", nil]; 
        [actionsheet showInView:self.view];
        
        UIPickerView *pkView=[[UIPickerView alloc] init];
        pkView.delegate=self;
        pkView.dataSource=self;
        pkView.showsSelectionIndicator=YES;
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //[actionsheet showInView:appDelegate.tabBarController.view];
        [actionsheet addSubview:pkView];
         } 
    
    //TmpCart *tc=[TmpCart getProductIfExistWithProductId:[NSNumber numberWithInt:self.productId] inManagedObjectContext:managedObjectContext];
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.tableView reloadData];
}
#pragma mark pickerview delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TmpCart *tc=[TmpCart getProductIfExistWithProductId:[NSNumber numberWithInt:self.productId] inManagedObjectContext:managedObjectContext];
    [myDataDescription replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[pickerView selectedRowInComponent:0]+1]]];
    tc.buyItemCount=[NSNumber numberWithInt:[pickerView selectedRowInComponent:0]+1];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:row+1]];
}

- (void)dealloc {
    [myData release];
    [super dealloc];
}

@end

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupNavigationBarButtons];
    items=[@"A*B*C*D*E*F*G*H*I*J*K*L" componentsSeparatedByString:@"*"];
    UITableViewController *tablePresentController=[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);  
    //UITableView *tableView = [[UITableView alloc] initWithFrame:rect]; 
    //[tablePresentController setTableView:tableView];
    //[tableView setDataSource:self];
    //[tableView setDelegate:self];
    [self.view addSubview:tablePresentController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setupNavigationBarButtons
{
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellStyle style=UITableViewCellStyleDefault;
    UITableViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:(@"BaseCell")];
    if (!cell) 
        cell=[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"BaseCell"];
        //cell.textLabel.text=[items objectAtIndex:indexPath.row];
        return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.title=[items objectAtIndex:indexPath.row];
}

-(void) loadView
{
    [super loadView];
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

