//
//  MemberIndexViewController.m
//  asoapp
//
//  Created by wyde on 12/5/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MemberIndexViewController.h"
#import "UINavigationController+Customize.h"
#import "LoginMember.h"
#import "MemberLoginViewController.h"
#import "AddToCartViewController.h"

@interface MemberIndexViewController ()

@end

@implementation MemberIndexViewController
@synthesize managedObjectContext;


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
    [self setupNavigationBarButtons];
    [self templateSculption];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)setupNavigationBarButtons
{
     
    // update/refresh button
	/*
    UIButton* updateButton = [self.navigationController createNavigationBarButtonWithText:NSLocalizedString(@"重新整理", nil) 
                                                                                     icon:CustomizeButtonIconReload
                                                                            iconPlacement:CustomizeButtonIconPlacementRight 
                                                                                   target:self 
                                                                                   action:@selector(test)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:updateButton] autorelease];
    */
    
    UIButton* backButton = [self.navigationController setUpCustomizeBackButton];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];    
}

-(void)test
{
    NSLog(@"test");
}

-(void) templateSculption
{
    UIButton *mycart = [UIButton buttonWithType:UIButtonTypeCustom];
    [mycart setTitle:@"我的購物車" forState:UIControlStateNormal];
    [mycart setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    mycart.frame = CGRectMake(74, 80, 172, 34);
    [mycart addTarget:self action:@selector(test)forControlEvents:UIControlEventTouchUpInside];
    [mycart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:mycart];
    
    UIButton *myrecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [myrecord setTitle:@"購買記錄" forState:UIControlStateNormal];
    [myrecord setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    myrecord.frame = CGRectMake(74, 140, 172, 34);
    [myrecord addTarget:self action:@selector(test)forControlEvents:UIControlEventTouchUpInside];
    [myrecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:myrecord];
    
    UIButton *mydata = [UIButton buttonWithType:UIButtonTypeCustom];
    [mydata setTitle:@"會員資料" forState:UIControlStateNormal];
    [mydata setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    mydata.frame = CGRectMake(74, 200, 172, 34);
    [mydata addTarget:self action:@selector(test)forControlEvents:UIControlEventTouchUpInside];
    [mydata setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:mydata];
    
    
    UIButton *logout = [self.navigationController setUpCustomizeBackButtonWithText:@"登出"];
    //[self.navigationController setUpCustomizeBackButton];
    //[logout setTitle:@"登出" forState:UIControlStateNormal];
    
    [logout setBackgroundImage:[[UIImage imageNamed:@"button1BG.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    logout.frame = CGRectMake(74, 300, 50, 34);
    [logout addTarget:self action:@selector(logout)forControlEvents:UIControlEventTouchUpInside];
    [logout setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:logout];
    
    
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];

    [self addLabelToMainView:@"歡迎" x:30 y:25 width:50 height:34 fontsize:12 alignment:UITextAlignmentLeft];
    [self addLabelToMainView:lm.account x:30 y:40 width:220 height:34 fontsize:12 alignment:UITextAlignmentLeft];
    
    
    
}

-(void) logout
{
    LoginMember *lm=[LoginMember getOrCreateMemberInManagedObjectContext:managedObjectContext];
    lm.logincheck=[NSNumber numberWithInt:0];
    lm.account=nil;
    //MemberLoginViewController *loginView=[[MemberLoginViewController alloc] init];
    //loginView.managedObjectContext = self.managedObjectContext;
    //[self.navigationController pushViewController:loginView animated:YES];
    //[loginView release];
}



-(void) addLabelToMainView:(NSString *)labelText x:(CGFloat)locationX y:(CGFloat)locationY width:(CGFloat)width height:(CGFloat)height fontsize:(CGFloat)fontsize alignment:(UITextAlignment)alignmentType
{
    UILabel *textFieldInfo=[[UILabel alloc] initWithFrame:CGRectMake(locationX, locationY, width, height)];
    textFieldInfo.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    textFieldInfo.text=labelText;
    textFieldInfo.font=[UIFont systemFontOfSize:fontsize];
    textFieldInfo.textAlignment=alignmentType;
    [self.view addSubview:textFieldInfo];
    [textFieldInfo release];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
