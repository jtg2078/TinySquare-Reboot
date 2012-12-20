//
//  QRscanningViewController.m
//  asoapp
//
//  Created by wyde on 12/4/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QRscanningViewController.h"
#import "UINavigationController+Customize.h"
#import "DataManager.h"
#import "ThemeManager.h"

#import "DetailCell.h"
#import "DetailCellModel.h"


@interface QRscanningViewController ()

@end

@implementation QRscanningViewController
@synthesize imgPicker=_imgPicker;
@synthesize resultTextView=_resultTextView;
@synthesize explain=_explain;
@synthesize qriconArea=_qriconArea;
@synthesize text1=_text1;
@synthesize text2=_text2;
@synthesize myButton=_myButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"優惠掃描", nil);

    
    if (self) {
        // Custom initialization
        
  
     }
    return self;
}

-(void)StartScan:(id) sender
{
      
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.readerView.torchMode = 0;
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
               config: ZBAR_CFG_ENABLE
                   to: 0];
      // present and release the controller
    [self presentModalViewController: reader
                        animated: YES];
    [reader release];
     
     resultTextView.hidden=NO;
    
}

-(void) recoverTabBar
{
    NSNumber *toshowBar = [NSNumber numberWithInt:1];
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:toshowBar];
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //hide tabBar below
    NSNumber *showBar = [NSNumber numberWithInt:0];
     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
     [center postNotificationName:@"com.fingertipcreative.tinysquare.showHideTabBar" object:showBar]; 
    
    
    // Create a custom back button
	UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    SEL backeventHandler = @selector(recoverTabBar);
    [backButton addTarget:self action:backeventHandler forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /*
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(100, 100, 200, 50);
    [myButton setTitle:@"按此開始掃描" forState:UIControlStateNormal];
    myButton.center=CGPointMake(160, 300);
    
    // setTintcolor can change the button color when onclick event
    [myButton setTintColor:[UIColor brownColor]];
    SEL eventHandler = @selector(StartScan:);
    [myButton addTarget:self action:eventHandler forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    
    resultTextView=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 180.0f)];
    resultTextView.text=@"掃描 阿瘦皮鞋歡慶六十週年 QRcode，至全台直營門市即可得優惠！";
    //label.text=@"hello world";
    resultTextView.center=CGPointMake(160, 120);
    [[resultTextView layer] setBorderWidth:1.0f];
    resultTextView.textAlignment=UITextAlignmentCenter;
    resultTextView.backgroundColor=[UIColor whiteColor];
    
    //auto change line if text is too long
    [resultTextView setNumberOfLines:0]; 
    resultTextView.lineBreakMode = UILineBreakModeWordWrap; 
    [self.view addSubview:resultTextView];
    */
    
    explain=[[UIImageView alloc] initWithFrame:CGRectMake(12,70,296,128)];
    UIImage* explainInfo=[UIImage imageNamed:@"qrNotiBG.png"];
    //explain.center=CGPointMake(160.0, 70.0+128.0/2);
    explain.image=explainInfo;
    [self.view addSubview:explain];
    
    qriconArea=[[UIImageView alloc] initWithFrame:CGRectMake(117, 202, 84, 74)];
    UIImage* qricon=[UIImage imageNamed:@"iconQR.png"];
    //qriconArea.center=CGPointMake(159.0, 202.0+74.0/2);
    qriconArea.image=qricon;
    [self.view addSubview:qriconArea];
    
    
    
    myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(74, 318, 172, 34);
    [myButton setTitle:@"開始掃描" forState:UIControlStateNormal];
    [myButton setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //setTintcolor can change the button color when onclick event
    //[myButton setTintColor:[UIColor brownColor]];
    
     [myButton addTarget:self action:@selector(StartScan:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    
    
    text1=[[UILabel alloc] initWithFrame:CGRectMake(16.0, 98.0, 288.0, 19.0)];
    text1.textAlignment=UITextAlignmentCenter;
    text1.backgroundColor=[UIColor clearColor];
    text1.text=@"阿瘦商品QRcode優惠實施中！";
    [self.view addSubview:text1];
    
    
    text2=[[UILabel alloc] initWithFrame:CGRectMake(16.0, 126.0, 288.0, 40.0)];
    text2.textAlignment=UITextAlignmentCenter;
    text2.backgroundColor=[UIColor clearColor];
    text2.lineBreakMode = UILineBreakModeWordWrap; 
    text2.numberOfLines = 0;
    text2.text=@"請按下開始掃描按鈕\n然後對準專屬QRcode";
    [self.view addSubview:text2];

    
    
        
    

}



- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
  
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// copy of the code
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    NSLog(@"the image picker failing to read");
    
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
        
    
    NSLog(@"the image picker is calling successfully %@",info);
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    NSString *hiddenData;
    for(symbol in results)
        hiddenData=[NSString stringWithString:symbol.data];
    NSLog(@"the symbols  is the following %@",symbol.data);
    // EXAMPLE: just grab the first barcode
    //  break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    resultTextView.text=symbol.data;
    
    
    NSLog(@"BARCODE= %@",symbol.data);
    
    NSUserDefaults *storeData=[NSUserDefaults standardUserDefaults];
    [storeData setObject:hiddenData forKey:@"CONSUMERID"];
    NSLog(@"SYMBOL : %@",hiddenData);
    //resultTextView.text=hiddenData;
    //NSLog(@"RESULTTEXT : %@",resultTextView.text);
    
    
    // change the text of the astring to whatever u want here
    //NSString *astring = [[NSString alloc] initWithString:@"阿瘦皮鞋歡慶六十週年"];
    
    
    bool compare=[hiddenData isEqualToString:@"阿瘦皮鞋歡慶六十週年"];
    if (compare)
    {
        //resultTextView.text=@"比對成功，恭喜您獲得優惠券";
        //resultTextView.textColor=[UIColor blueColor];
        NSLog(@"compare sucess");
        [myButton setTitle:@"重新掃描" forState:UIControlStateNormal];
        text1.text=@"";
        
        UIImage* correctPic=[UIImage imageNamed:@"38-56-600.jpg"];
        [qriconArea setFrame:CGRectMake(10, 20, 300, 225)];
        qriconArea.image=correctPic;

        
        UIImage* picBack=[UIImage imageNamed:@"qrPicBG.png"];
        [explain setFrame:CGRectMake(4, 14, 312, 247)];
        explain.image=picBack;
        
        
                
        [text2 setFrame:CGRectMake(8, 254, 304, 60)];
        [text2 setNumberOfLines:0]; 
        text2.lineBreakMode = UILineBreakModeWordWrap;
        [text2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        text2.textAlignment=UITextAlignmentLeft;
        text2.text=@"阿瘦春夏新品上市，若來店出示本頁面，針對特定商品享有特價8折優惠！";
        
    }else {
        //resultTextView.text=@"此為無效QRcode，請重新掃描";
        //resultTextView.textColor=[UIColor redColor];
        //check text1 text2 myButton qriconArea explain
        
        NSLog(@"fail to compare");
        qriconArea.image=nil;
        
        text1.textAlignment=UITextAlignmentLeft;
        text1.text=@"此為無效QRcode";
        [text1 setFrame:CGRectMake(102, 106, 178, 22)];
        text2.textAlignment=UITextAlignmentLeft;
        text2.text=@"請重新掃描";
        [text2 setFrame:CGRectMake(102, 134, 178, 22)];
        UIImage* failInfo=[UIImage imageNamed:@"qrFailedBG.png"];
        [explain setFrame:CGRectMake(12,70,296,128)];
        explain.image=failInfo;
        [myButton setTitle:@"重新掃描" forState:UIControlStateNormal];
       
        
    }
    //[astring release];
    
    
    [reader dismissModalViewControllerAnimated: NO];
    
     
}


@end
