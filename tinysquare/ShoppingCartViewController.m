//
//  ShoppingCartViewController.m
//  TinySquare
//
//  Created by jason on 12/28/12.
//
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"

#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"

#import "TmpProduct.h"

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myTableView release];
    [_myHeaderView release];
    [_totalItemCountLabel release];
    [_totalAmountLabel release];
    [_shippingCostLabel release];
    [_freeShippingCostLabel release];
    [_checkoutCostLabel release];
    [_buyButton release];
    [_inputToolbar release];
    [_dismissKeyboardButton release];
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
    
    // -------------------- table view related --------------------
    
    // setup table view
    self.myTableView.tableHeaderView = self.myHeaderView;
    
    // setup cell nib
    NSString *cellIdentifier = @"ShoppingCartCellIdentifier";
    UINib *cellNib = [UINib nibWithNibName:@"ShoppingCartCell" bundle:nil];
    [self.myTableView registerNib:cellNib
           forCellReuseIdentifier:cellIdentifier];
    
    // config table view
    self.myTableView.rowHeight = 116;
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMyHeaderView:nil];
    [self setTotalItemCountLabel:nil];
    [self setTotalAmountLabel:nil];
    [self setShippingCostLabel:nil];
    [self setFreeShippingCostLabel:nil];
    [self setCheckoutCostLabel:nil];
    [self setBuyButton:nil];
    [self setInputToolbar:nil];
    [self setDismissKeyboardButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeForKeyboardEvents];
    
    [self refreshShoppingCart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsubscribeFromKeyboardEvents];
    
    [super viewWillDisappear:animated];
}

#pragma mark - shopping cart related

- (void)refreshShoppingCart
{
    [self.appManager processTempCart:^{
        
        int itemCount = 0;
        int amount = 0;
        NSMutableArray *pidArray = [NSMutableArray array];
        self.countDict = [NSMutableDictionary dictionary];
        
        for(NSDictionary *p in self.appManager.cartReal[CART_KEY_products])
        {
            itemCount += [p[CART_ITEM_KEY_size] intValue];
            amount += [p[CART_ITEM_KEY_price] intValue];
            [pidArray addObject:p[CART_ITEM_KEY_pid]];
            [self.countDict setObject:p[CART_ITEM_KEY_size] forKey:p[CART_ITEM_KEY_pid]];
        }
        
        self.totalItemCountLabel.text = [@(itemCount) stringValue];
        self.totalAmountLabel.text = [@(amount) stringValue];
        self.shippingCostLabel.text = [self.appManager.cartReal[CART_KEY_shippingfees] stringValue];
        self.freeShippingCostLabel.text = [self.appManager.cartReal[CART_KEY_noshippingfee] stringValue];
        self.checkoutCostLabel.text = [self.appManager.cartReal[CART_KEY_total] stringValue];
        
        [self getProductDetailForShoppingCart:pidArray];
        
        [self.myTableView reloadData];
        
    } needLogin:^{
        
        [SVProgressHUD showErrorWithStatus:@"請先登入"];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:errorMessage];
        
    }];
}

- (void)getProductDetailForShoppingCart:(NSArray *)pidArray
{
    NSManagedObjectContext *managedObjectContext = self.appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"TmpProduct" inManagedObjectContext:managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"productId IN %@", pidArray];
    
    NSError *err = nil;
    self.productArray = [managedObjectContext executeFetchRequest:request error:&err];
}

#pragma mark - keyboard

- (void)subscribeForKeyboardEvents
{
    tableViewWidth = self.myTableView.frame.size.width;
    tableViewHeight = self.myTableView.frame.size.height;
    
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardEvents
{
    /* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Note: rects are in screen coordinates, need to convert it
    endFrame = [self.view convertRect:endFrame fromView:nil];
    
    CGSize contentSize = self.myTableView.contentSize;
    contentSize.height += endFrame.size.height;
    
    self.myTableView.contentSize = contentSize;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // Note: rects are in screen coordinates, need to convert it
    endFrame = [self.view convertRect:endFrame fromView:nil];
    
    CGSize contentSize = self.myTableView.contentSize;
    contentSize.height -= endFrame.size.height;
    self.myTableView.contentSize = contentSize;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.superview.superview isKindOfClass:[ShoppingCartCell class]] == YES)
    {
        ShoppingCartCell *cell = (ShoppingCartCell *)textField.superview.superview;
        NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ShoppingCartCellIdentifier";
    
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell.countTextField.inputAccessoryView = self.inputToolbar;
    cell.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    cell.countTextField.delegate = self;
    
    TmpProduct *p = (TmpProduct *)[self.productArray objectAtIndex:indexPath.row];
    
    cell.discountPriceLabel.text = p.salePrice.stringValue;
    cell.originalPriceLabel.text = p.price.stringValue;
    cell.productNameLabel.text = p.productName;
    cell.countTextField.text = [[self.countDict objectForKey:p.productId] stringValue];
    //cell.stockCountLabel;
    //cell.lastUpdatedTimeLabel;
    
    NSString *imageURL = [TmpProduct getFirstProductImageWithSize:TmpProductImageSize100
                                                        imageJson:p.imagesJson];
    [cell.productImageView setImageWithURL:[NSURL URLWithString:imageURL]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - user interaction

- (IBAction)buyButtonPressed:(id)sender
{
    
}

- (IBAction)closeKeyboardButtonPressed:(id)sender
{
    [self.view endEditing:YES];
}
@end
