//
//  SettingsViewController.m
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeObject.h"
#import "ThemeManager.h"
#import "UINavigationController+Customize.h"
#import "AppDelegate.h"

@interface SettingsViewController ()
- (void)dismissSettingsViewController;
- (void)applyTheme;
@end


@implementation SettingsViewController

#pragma mark - define

#pragma mark - macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#pragma mark - synthesize

@synthesize sectionNameArray;
@synthesize sectionDataArray;
@synthesize selectedIndex;

#pragma mark - dealloc

- (void)dealloc {
    [sectionNameArray release];
    [sectionDataArray release];
    [super dealloc];
}

#pragma mark - init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark user interactions

- (void)dismissSettingsViewController 
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup close button
	UIButton* closeButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"返回", nil)
																			   icon:CustomizeButtonIconEdit
																	  iconPlacement:CustomizeButtonIconPlacementLeft 
																			 target:self 
																			 action:@selector(dismissSettingsViewController)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeButton] autorelease];
    
    self.sectionNameArray = [NSArray arrayWithObjects:@"Theme Selection", @"Others", nil];
    NSMutableArray *array = [NSMutableArray array];
    
    // setup theme section
    themeManager = [ThemeManager sharedInstance];
    [array addObject:[themeManager getListOfThemes]];
    
    // setup others section
    [array addObject:[NSMutableArray array]];
    
    self.sectionDataArray = array;
    
    // default theme to be 0
    self.selectedIndex = 0;
    self.selectedIndex = themeManager.selectedThemeIndex;
    NSLog(@"%d", self.selectedIndex);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark utilities methods

- (void)applyTheme {
    // refresh navigation bar buttons
    UIButton* closeButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"返回", nil)
                                                                                    icon:CustomizeButtonIconEdit
                                                                           iconPlacement:CustomizeButtonIconPlacementLeft 
                                                                                  target:self 
                                                                                  action:@selector(dismissSettingsViewController)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeButton] autorelease];
    [self.navigationController applyTheme];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionNameArray objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionNameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionDataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if(indexPath.section == 0)
    {
        ThemeObject *theme = [[self.sectionDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = theme.themeName;
        cell.textLabel.textColor = theme.themeColor;
        
        if(indexPath.row == themeManager.selectedThemeIndex)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:themeManager.selectedThemeIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndex];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark && self.selectedIndex != indexPath.row) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [themeManager setTheme:indexPath.row fireNotification:YES];
        
        [self applyTheme];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissSettingsViewController];
        });
    }
}

@end
