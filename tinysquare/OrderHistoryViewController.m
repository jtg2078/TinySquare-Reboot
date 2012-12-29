//
//  OrderHistoryViewController.m
//  TinySquare
//
//  Created by jason on 12/29/12.
//
//

#import "OrderHistoryViewController.h"

#import "OrderHeaderCell.h"
#import "OrderFirstCell.h"
#import "OrderMiddleCell.h"
#import "OrderLastCell.h"

#import "SVProgressHUD.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"

@interface OrderHistoryViewController ()

@end

@implementation OrderHistoryViewController

#pragma mark - define

#define HEADER_CELL_COLLAPSED 50
#define HEADER_CELL_EXPANDED 51

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myTableView release];
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

- (void)refresh
{
    // state keeping
    self.headerStateArray = [NSMutableArray array];
    for(int i = 0; i < self.appManager.allCarts.count; i++)
    {
        [self.headerStateArray addObject:@(NO)];
    }
    
    self.cartAdditionalInfo = [NSMutableDictionary dictionary];
    
    [self.myTableView reloadData];
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // -------------------- navigation bar --------------------
    
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton* memberShip2Button = [self.navigationController createNavigationBarButtonWithOutTextandSetIcon:CustomizeButtonIconCollapse
                                                                                              iconPlacement:CustomizeButtonIconPlacementRight
                                                                                                     target:self
                                                                                                     action:@selector(refresh)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:memberShip2Button] autorelease];
    
    // -------------------- table view related --------------------
    
    // setup cell nibs
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderHeaderCell" bundle:nil]
           forCellReuseIdentifier:@"OrderHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderFirstCell" bundle:nil]
           forCellReuseIdentifier:@"OrderFirstCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderMiddleCell" bundle:nil]
           forCellReuseIdentifier:@"OrderMiddleCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderLastCell" bundle:nil]
           forCellReuseIdentifier:@"OrderLastCell"];
    
    // -------------------- get all carts --------------------
    
    [SVProgressHUD showWithStatus:@"讀取中"];
    [self.appManager getAllShoppingCarts:^(int code, NSString *msg) {
        
        [SVProgressHUD showSuccessWithStatus:msg];
        [self refresh];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:errorMessage];
        
    }];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.appManager.allCarts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL state = [[self.headerStateArray objectAtIndex:section] boolValue];
    NSArray *products = self.appManager.allCarts[section][CART_KEY_products];
    return state ? 2 + products.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier = @"OrderHeaderCell";
        OrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        BOOL expandState = [self.headerStateArray[indexPath.section] boolValue];
        cell.lineImageView.hidden = expandState;
        cell.arrowImageView.image = expandState ? [UIImage imageNamed:@"history - arrow_down"] : [UIImage imageNamed:@"history - arrow_right"];
        
        // config data
        NSDictionary *cart = self.appManager.allCarts[indexPath.section];
        int cartStatus = [cart[CART_KEY_status] intValue];
        if(cartStatus == CART_STATUS_success)
            cell.iconImageView.image = [UIImage imageNamed:@"Transaction Icon1"];
        else
            cell.iconImageView.image = [UIImage imageNamed:@"Transaction Icon2"];
        cell.orderNumberLabel.text = [cart[CART_KEY_orderid] stringValue];
        cell.orderTotalLabel.text = [cart[CART_KEY_total] stringValue];
        
        return cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *cellIdentifier = @"OrderFirstCell";
        OrderFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //readjust index
        int index = indexPath.row - 1;
        
        // config data
        NSDictionary *product = self.appManager.allCarts[indexPath.section][CART_KEY_products][index];
        cell.productNameLabel.text = product[CART_ITEM_KEY_pname];
        cell.unitPriceLabel.text = [product[CART_ITEM_KEY_price] stringValue];
        cell.countLabel.text = [product[CART_ITEM_KEY_size] stringValue];
        cell.sumLabel.text = [product[CART_ITEM_KEY_amount] stringValue];
        
        return cell;
    }
    else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1)
    {
        static NSString *cellIdentifier = @"OrderLastCell";
        OrderLastCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSDictionary *cart = self.appManager.allCarts[indexPath.section];
        cell.totalCountLabel.text = [self.cartAdditionalInfo[@(indexPath.section)] stringValue];
        cell.sumPriceLabel.text = [cart[CART_KEY_total] stringValue];
        cell.shippingLabel.text = [cart[CART_KEY_shippingfees] stringValue];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"OrderMiddleCell";
        OrderMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //readjust index
        int index = indexPath.row - 1;
        
        // config data
        NSDictionary *product = self.appManager.allCarts[indexPath.section][CART_KEY_products][index];
        cell.productNameLabel.text = product[CART_ITEM_KEY_pname];
        cell.unitPriceLabel.text = [product[CART_ITEM_KEY_price] stringValue];
        cell.unitLabel.text = [product[CART_ITEM_KEY_size] stringValue];
        cell.sumLabel.text = [product[CART_ITEM_KEY_amount] stringValue];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 80;
    }
    else if(indexPath.row == 1)
    {
        return 150;
    }
    else
    {
        NSArray *products = self.appManager.allCarts[indexPath.section][CART_KEY_products];
        
        if(indexPath.row == products.count + 1)
        {
            return 127;
        }
        else
        {
            return 125;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        BOOL state = [self.headerStateArray[indexPath.section] boolValue];
        [self.headerStateArray replaceObjectAtIndex:indexPath.section withObject:@(!state)];
        
        if(!self.cartAdditionalInfo[@(indexPath.section)])
        {
            int total = 0;
            for(NSDictionary *p in self.appManager.allCarts[indexPath.section][CART_KEY_products])
            {
                total += [p[CART_ITEM_KEY_size] intValue];
            }
            self.cartAdditionalInfo[@(indexPath.section)] = @(total);
        }
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - (not used) section header view related

/*
 
// in h file
@property (retain, nonatomic) NSMutableDictionary *expandedHeaders;
@property (retain, nonatomic) NSMutableArray *headerCellQueue;
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderCell *cell = [self dequeueReusableHeaderCell];
    
    if(cell == nil)
    {
        NSLog(@"called");
        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderCell"];
        if(cell.gestureRecognizer == nil)
        {
            UITapGestureRecognizer *gs = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerCellTapped:)] autorelease];
            cell.gestureRecognizer = gs;
            [cell.contentView addGestureRecognizer:gs];
        }
        
        [self.headerCellQueue addObject:cell];
    }
    
    cell.sectionIndex = section;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (OrderHeaderCell *)dequeueReusableHeaderCell
{
    if(!self.headerCellQueue)
        self.headerCellQueue = [NSMutableArray array];
    
    NSUInteger index = [self.headerCellQueue indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return [obj superview] == nil;}];
    
    return index == NSNotFound ? nil : [self.headerCellQueue objectAtIndex:index];
}

- (void)headerCellTapped:(UITapGestureRecognizer *)sender
{
    OrderHeaderCell *cell = (OrderHeaderCell *)sender.view.superview;
    
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:cell.sectionIndex]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([self.expandedHeaders objectForKey:@(cell.sectionIndex)])
    {
        // expanded --> collapse
        [self.expandedHeaders removeObjectForKey:@(cell.sectionIndex)];
        [SVProgressHUD showSuccessWithStatus:@"will collapse"];
    }
    else
    {
        // collapsed --> expand
        [self.expandedHeaders setObject:@(cell.sectionIndex) forKey:@(cell.sectionIndex)];
        [SVProgressHUD showSuccessWithStatus:@"will expand"];
    }
}
*/

@end
