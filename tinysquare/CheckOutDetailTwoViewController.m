//
//  CheckOutDetailTwoViewController.m
//  TinySquare
//
//  Created by jason on 12/30/12.
//
//

#import "CheckOutDetailTwoViewController.h"

#import "InvoiceDetailCell.h"

#import "SVProgressHUD.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Customize.h"

@interface CheckOutDetailTwoViewController ()

@end

@implementation CheckOutDetailTwoViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myTableView release];
    [_memberNameLabel release];
    [_tableViewBgImageView release];
    [_nextStepButton release];
    [_myTableHeaderView release];
    [_myTableFooterView release];
    [_recipientNameLabel release];
    [_addressLabel release];
    [_phoneLabel release];
    [_deliverTimeLabel release];
    [_noteLabel release];
    [_totalItemCountLabel release];
    [_totalProductPriceLabel release];
    [_shippingLabel release];
    [_receiptNameLabel release];
    [_taxIDLabel release];
    [_receiptAddressLabel release];
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
    
    // -------------------- navigation bar --------------------
    
	UIButton* backButton = [self.navigationController setUpCustomizeBackButtonWithText:NSLocalizedString(@"返回", nil)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    // -------------------- view related --------------------
    
    UIImage *bgImage = [[UIImage imageNamed:@"detail2 - invoice column.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 30, 0)];
    self.tableViewBgImageView.image = bgImage;
    
    if(self.appManager.userInfo)
        self.memberNameLabel.text = [NSString stringWithFormat:@"%@ 您好", self.appManager.userInfo[@"name"]];
    
    // -------------------- table view related --------------------
    
    // setup cell nibs
    [self.myTableView registerNib:[UINib nibWithNibName:@"InvoiceDetailCell" bundle:nil] forCellReuseIdentifier:@"InvoiceDetailCell"];
    
    // config table view
    self.myTableView.rowHeight = 112;
    
    //config header and footer
    self.myTableView.tableHeaderView = self.myTableHeaderView;
    self.myTableView.tableFooterView = self.myTableFooterView;
    
    self.recipientNameLabel.text = self.recipientName;
    self.addressLabel.text = self.address;
    self.phoneLabel.text = self.phone;
    self.deliverTimeLabel.text = self.deliverTime;
    self.noteLabel.text = self.note;
    
    int itemCount = 0;
    for(NSDictionary *p in self.appManager.cartReal[CART_KEY_products])
    {
        itemCount += [p[CART_ITEM_KEY_size] intValue];
    }
    
    self.totalItemCountLabel.text = [@(itemCount) stringValue];
    self.totalProductPriceLabel.text = [self.appManager.cartReal[CART_KEY_total] stringValue];
    self.shippingLabel.text = [self.appManager.cartReal[CART_KEY_shippingfees] stringValue];
    self.receiptNameLabel.text = self.receiptName;
    self.receiptAddressLabel.text = self.receiptAddress;
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setMemberNameLabel:nil];
    [self setTableViewBgImageView:nil];
    [self setNextStepButton:nil];
    [self setMyTableHeaderView:nil];
    [self setMyTableFooterView:nil];
    [self setRecipientNameLabel:nil];
    [self setAddressLabel:nil];
    [self setPhoneLabel:nil];
    [self setDeliverTimeLabel:nil];
    [self setNoteLabel:nil];
    [self setTotalItemCountLabel:nil];
    [self setTotalProductPriceLabel:nil];
    [self setShippingLabel:nil];
    [self setReceiptNameLabel:nil];
    [self setTaxIDLabel:nil];
    [self setReceiptAddressLabel:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.appManager.cartReal[CART_KEY_products] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InvoiceDetailCell";
    InvoiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // config data
    NSDictionary *product = self.appManager.cartReal[CART_KEY_products][indexPath.row];
    cell.productNameLabel.text = product[CART_ITEM_KEY_pname];
    cell.unitPriceLabel.text = [product[CART_ITEM_KEY_price] stringValue];
    cell.unitLabel.text = [product[CART_ITEM_KEY_size] stringValue];
    cell.sumLabel.text = [product[CART_ITEM_KEY_amount] stringValue];
    
    return cell;
}

#pragma mark - user interaction

- (IBAction)nextStepButtonPressed:(id)sender
{
}

@end
