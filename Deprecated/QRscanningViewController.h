//
//  QRscanningViewController.h
//  asoapp
//
//  Created by wyde on 12/4/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseDetailViewController.h"
#import "ZBarSDK.h"





//@interface QRscanningViewController : BaseDetailViewController <MFMailComposeViewControllerDelegate> {
@interface QRscanningViewController : UIViewController<UIImagePickerControllerDelegate,ZBarReaderDelegate>{
    UILabel *resultTextView;
    UIImageView *explain;
    UIImageView *qriconArea;
    UIButton *myButton;
    UILabel *text1;
    UILabel *text2;

}
@property (nonatomic, retain) UILabel *resultTextView;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain)UIImageView *explain;
@property (nonatomic, retain)UIImageView *qriconArea;
@property (nonatomic, retain)UIButton *myButton;
@property (nonatomic, retain)UILabel *text1;
@property (nonatomic, retain)UILabel *text2;


-(void)StartScan:(id) sender;

@end



