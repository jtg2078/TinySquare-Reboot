//
//  MemberMainViewController.m
//  asoapp
//
//  Created by jason on 12/19/12.
//
//

#import "MemberMainViewController.h"
#import "EditMemeberViewController.h"
#import "IIViewDeckController.h"

@interface MemberMainViewController ()
@property (retain, nonatomic) NSArray *menuInfo;
@end

@implementation MemberMainViewController

#pragma mark - getter

- (NSArray *)menuInfo
{
    if(!_menuInfo)
    {
        _menuInfo =[@[
            [@{
                @"title" : @"尚未成為會員",
                @"icon": @"not member pic",
                @"tap": @"none",
                @"view": [NSNull null],
            } mutableCopy],
            [@{
                @"title" : @"會員資料",
                @"icon": @"member",
                @"tap": @"expand",
                @"state": @"collapsed",
                @"view": [NSNull null],
                @"contain": @[
                        @{
                            @"title" : @"我要註冊",
                            @"icon" : @"register ",
                        },
                        @{
                            @"title" : @"登入",
                            @"icon" : @"login",
                        },
                        @{
                            @"title" : @"修改會員資料",
                            @"icon" : @"modify ",
                        },
                    ],
            } mutableCopy],
            [@{
                @"title" : @"購物記錄",
                @"icon": @"shopping records ",
                @"tap": @"select",
                @"view": [NSNull null],
            } mutableCopy],
            [@{
                @"title" : @"意見回饋",
                @"icon": @"opinion ",
                @"tap": @"select",
                @"view": [NSNull null],
            } mutableCopy],
            [@{
                @"title" : @"使用條款",
                @"icon": @"clause ",
                @"tap": @"select",
                @"view": [NSNull null],
            } mutableCopy],
        ] retain];
    }
    return _menuInfo;
}

#pragma mark - memeory management

- (void)dealloc
{
    [_myTableView release];
    [_mySearchBar release];
    [_menuInfo release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMySearchBar:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    NSMutableDictionary *info = self.menuInfo[section];
    NSArray *cells = [info objectForKey:@"contain"];
    if(cells && [info[@"state"] isEqualToString:@"expanded"])
    {
        count = cells.count;
    }
        
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MemberMainCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.indentationLevel = 3;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    NSDictionary *info = self.menuInfo[indexPath.section][@"contain"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:info[@"icon"]];
    cell.textLabel.text = info[@"title"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *info = self.menuInfo[section];
    UIView *headerView = info[@"view"];
    if([headerView isKindOfClass:[NSNull class]])
    {
        UIView *v = [[[UIView alloc] init] autorelease];
        v.frame = CGRectMake(0, 0, tableView.frame.size.width, 44);
        v.backgroundColor = [UIColor clearColor];
        
        UIImage *iconImage = [UIImage imageNamed:info[@"icon"]];
        UIImageView *iconImageView = [[[UIImageView alloc] initWithImage:iconImage] autorelease];
        iconImageView.frame = CGRectMake(9, 4, iconImage.size.width, iconImage.size.height);
        [v addSubview:iconImageView];
        
        UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.frame = CGRectMake(51, 12, 158, 19);
        titleLabel.text = info[@"title"];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [v addSubview:titleLabel];
        
        if([info[@"tap"] isEqualToString:@"expand"])
        {
            UIImage *accessoryImage = [UIImage imageNamed:@"arrow_down "];
            UIImageView *accessoryImageView = [[[UIImageView alloc] initWithImage:accessoryImage] autorelease];
            accessoryImageView.frame = CGRectMake(227, 12, accessoryImage.size.width, accessoryImage.size.height);
            [v addSubview:accessoryImageView];
            
            UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapped:)] autorelease];
            [v addGestureRecognizer:tapGesture];
        }
        else if([info[@"tap"] isEqualToString:@"select"])
        {
            UIImage *accessoryImage = [UIImage imageNamed:@"arrow_right "];
            UIImageView *accessoryImageView = [[[UIImageView alloc] initWithImage:accessoryImage] autorelease];
            accessoryImageView.frame = CGRectMake(227, 12, accessoryImage.size.width, accessoryImage.size.height);
            [v addSubview:accessoryImageView];
            
            UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderViewTapped:)] autorelease];
            [v addGestureRecognizer:tapGesture];
        }
        
        [info setObject:v forKey:@"view"];
        headerView = v;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - section header view

- (void)sectionHeaderViewTapped:(UITapGestureRecognizer *)sender
{
    int index = 0;
    for(NSMutableDictionary *info in self.menuInfo)
    {
        if(info[@"view"] == sender.view)
        {
            if([info[@"tap"] isEqualToString:@"expand"] == YES)
            {
                if([info[@"state"] isEqualToString:@"collapsed"])
                {
                    [info setObject:@"expanded" forKey:@"state"];
                }
                else
                {
                    [info setObject:@"collapsed" forKey:@"state"];
                }
                
                [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if([info[@"tap"] isEqualToString:@"select"] == YES)
            {
                EditMemeberViewController *emvc = [[[EditMemeberViewController alloc] init] autorelease];
                [self.viewDeckController rightViewPushViewControllerOverCenterController:emvc];
            }
            
            break;
        }
        index++;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

@end
