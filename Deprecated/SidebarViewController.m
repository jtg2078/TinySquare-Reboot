//
//  SidebarViewController.m
//  asoapp
//
//  Created by wyde on 12/10/29.
//
//

//
#import "SidebarViewController.h"


@implementation SidebarViewController
@synthesize sidebarDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *sidebarBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 460)];
    //[self.view addSubview:sidebarBg];
    [sidebarBg setImage:[UIImage imageNamed:@"sidebarBg.png"]];
    self.tableView.backgroundView=sidebarBg;
    [sidebarBg release];
    myData=[[NSArray alloc] initWithObjects:@"歡迎登入",@"會員資料",@"購物記錄",@"意見回饋", nil];
    sideImage=[[NSArray alloc] initWithObjects:
               [UIImage imageNamed:@"not_member_pic.png"],
               [UIImage imageNamed:@"member_little.png"],
               [UIImage imageNamed:@"clause.png"],
               [UIImage imageNamed:@"opinion.png"],
               nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SidebarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = (NSString*)[myData objectAtIndex:indexPath.row];
    //[cell.imageView setImage:[UIImage imageNamed:@"register.png"]];
    cell.imageView.image=(UIImage*)[sideImage objectAtIndex:indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"ViewController%d", indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sidebarDelegate) {
        NSObject *object = [NSString stringWithFormat:@"%@", [myData objectAtIndex:indexPath.row]];
        [self.sidebarDelegate sidebarViewController:self didSelectObject:object atIndexPath:indexPath];
    }
}

@end
