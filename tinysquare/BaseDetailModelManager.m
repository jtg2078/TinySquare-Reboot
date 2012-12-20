//
//  DetailModelManager.m
//  NTIFO_01
//
//  Created by jason on 2011/9/2.
//  Copyright 2011 Fingertip Creative. All rights reserved.
//

#import "BaseDetailModelManager.h"

#import "UIImage+Transform.h"


#import "Item.h"
#import "ProductItem.h"
#import "Product.h"
#import "LocationItem.h"
#import "Location.h"
#import "AssociationItem.h"
#import "Association.h"
#import "RecipeItem.h"
#import "Recipe.h"
#import "ItemImage.h"

#import "TmpHotProduct.h"
#import "TmpProduct.h"
#import "TmpSavedProduct.h"
#import "TmpImage.h"


@implementation BaseDetailModelManager

#pragma mark -
#pragma mark synthesize

@synthesize delegate;
//@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize itemId;
@synthesize error;
@synthesize cellList;
@synthesize detailInfo;

#pragma mark - 
#pragma mark define

#define NEW_JSON_IMAGE_TYPE_PHOTO                   0
#define NEW_JSON_IMAGE_TYPE_AD                      1


#pragma mark -
#pragma mark constructor

- (id)initWithItemId:(int)number 
{
	if(self = [super init])
	{
		fontForCalculateCellHeight = [[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f] retain];
		// set up background dispatch queue
		backgroundQueue = dispatch_queue_create("com.fingertipcreative.tinysquare.BaseDetailModelManager.backgroundQueue", NULL);
		itemId = number;
	}
	else 
	{
		self = nil;
	}
	return self;
}

- (void)dealloc
{
	dispatch_release(backgroundQueue);
	[error release];
	[cellList release];
	[fontForCalculateCellHeight release];
	[detailInfo release];
    [managedObjectContext release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark main methods

- (void)createDetailCellList
{
    
}

- (void)createDetailCellListForAboutMe
{
	if (delegate && [delegate respondsToSelector:@selector(createDetailCellListStarted:)]) 
	{
		[delegate performSelector:@selector(createDetailCellListStarted:) withObject:self];
	}
	
	dispatch_async(backgroundQueue, ^(void) 
   {
	   NSMutableArray *array = [NSMutableArray array];
	   
	   
	   // title and three images overlay
	   DetailCellModel *titleImageModel = [self createTitleAndImageModel:@"林蔭道的流行圈" 
																  images:[NSArray arrayWithObjects:
																		  [[UIImage imageNamed:@"Aboutus-pics-Logo.png"] imageRotatedByDegrees:-5.5],
																		  [[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png", itemId]] imageRotatedByDegrees:1.5],
																		  [[UIImage imageNamed:[NSString stringWithFormat:@"%d-3.png", itemId]] imageRotatedByDegrees:0.5], nil]];
	   titleImageModel.cellType = CellTypeTitleAndImagesStatic;
	   titleImageModel.selectedResponse = CellSelectedResponseNone;
	   titleImageModel.hasAccessory = NO;
	   [array addObject:titleImageModel];
	   
	   // summary
	   [array addObject:[self createSummaryModel:@"韓國新沙洞林蔭道是指從地鐵三號線新沙站到現代高中之間相通的一條街道。那邊可以體驗最優閒的韓國午後以及後現代與藝術結合的時尚饗宴。"]];
	   
	   // detail summary
	   [array addObject:[self createAboutMeDetailDesc:@"韓國新沙洞林蔭道是指從地鐵三號線新沙站到現代高中之間相通的一條街道。那邊可以體驗最優閒的韓國午後以及後現代與藝術結合的時尚饗宴。韓國新沙洞林蔭道是指從地鐵三號線新沙站到現代高中之間相通的一條街道。那邊可以體驗最優閒的韓國午後以及後現代與藝術結合的時尚饗宴。今年秋天，擁有這件時尚風衣，宛如走在林蔭道一樣的悠游自在。"]];
	   
	   // url
	   [array addObject:[self createWebUrlModel:@"http://shopping.pchome.com.tw/DIBO0M-A56592076"]];
	   
	   self.cellList = array;
	   
	   [self performSelectorOnMainThread:@selector(reportCreateFinished) withObject:nil 
						   waitUntilDone:[NSThread isMainThread]];
   });
}

- (void)reportCreateFinished
{
	if (delegate && [delegate respondsToSelector:@selector(createDetailCellListFinished:)]) 
	{
		[delegate performSelector:@selector(createDetailCellListFinished:) withObject:self];
	}
}

- (void)reportCreateFailed
{
	if (delegate && [delegate respondsToSelector:@selector(createDetailCellListFailed:)]) 
	{
		[delegate performSelector:@selector(createDetailCellListFailed:) withObject:self];
	}
}

- (void)clearDetailCellList
{
	self.cellList = nil;
}

- (void)addToBookmarkAndShowIndicatorInView:(UIView *)aView
{
    
}


#pragma mark -
#pragma mark model creation

- (DetailCellModel *)createModelWithType:(CellType)type Title:(NSString *)aTitle contentText:(NSString *)aText
{
	DetailCellModel *model = [[DetailCellModel alloc] init];
	model.cellType = type;
	model.title = aTitle;
	model.displayContent = aText;
	model.hasAccessory = NO;
	
	if(model.cellType == CellTypeMultiLineNoTitle)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(288, 10000)].height;
		model.totalHeight = model.contentHeight + 20;
	}
	
	if(model.cellType == CellTypeSingleLine2WordTitle)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(235, 10000)].height;
		model.totalHeight = 44;
	}
    
    if(model.cellType == CellTypeSingleLine3WordTitle)
    {
        model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
                                               constrainedToSize:CGSizeMake(228, 10000)].height;
		model.totalHeight = 44;
    }
    
    if(model.cellType == CellTypeSingleLineCenterNoTitle)
    {
        model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
                                               constrainedToSize:CGSizeMake(288, 10000)].height;
		model.totalHeight = 44;
    }
    
	if(model.cellType == CellTypeMultiLine2WordTitle)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(235, 10000)].height;
		model.totalHeight = model.contentHeight;
	}
	
	if(model.cellType == CellTypeMultiLine4WordTitle)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(210, 10000)].height;
		model.totalHeight = model.contentHeight + 28;
	}
	
	if(model.cellType == CellTypeMultiLineStandAloneTitle)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(288, 10000)].height;
		model.totalHeight = model.contentHeight + 48;
	}
	
	if(model.cellType == CellTypeAddressAndMap)
	{
		model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
										constrainedToSize:CGSizeMake(150, 10000)].height;
		model.totalHeight = 70;
	}
    
    if(model.cellType == CellTypeTitleAndImagesEnhanced)
    {
        model.contentHeight = 320;
        model.totalHeight = 325;
        
    }
    
    if(model.cellType == CellTypeCustomAttribute)
    {
        /*
         - find out the title length,       a
         - find out the content length,     z
         - find out the margin between the  title and content g
         - if (a + g + z) > one line width
            - if (a) > one line width
                - CellTypeMultiLineMultiWordTitle
            else
                - CellTypeMultiLineStandAloneTitle
         - else
            - CellTypeSingleLineMultiWordTitle
         fontForTitle = [[UIFont fontWithName:@"STHeitiTC-Medium" size:18.0f] retain];
         fontForRest = [[UIFont fontWithName:@"STHeitiTC-Medium" size:13.0f] retain];
         */
        int titleContentMargin = 5;
        int lineWidth = 288;
        CGFloat titleWidth = [model.title sizeWithFont:fontForCalculateCellHeight].width;
        CGFloat contentWidth = [model.displayContent sizeWithFont:fontForCalculateCellHeight].width;
        if(titleWidth + titleContentMargin + contentWidth > lineWidth)
        {
             if(titleWidth >= 288)
             {
                 CGFloat titleHeight = [model.title sizeWithFont:fontForCalculateCellHeight constrainedToSize:CGSizeMake(288, 10000)].height;
                 CGFloat contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight constrainedToSize:CGSizeMake(288, 10000)].height;
                 
                 model.cellType = CellTypeMultiLineMultiWordTitle;
                 model.titleHeight = titleHeight;
                 model.contentHeight = MAX(contentHeight, 35);
                 model.totalHeight = model.titleHeight + model.contentHeight + 10;
             }
             else
             {
                 model.cellType = CellTypeMultiLineStandAloneTitle;
                 model.contentHeight = [model.displayContent sizeWithFont:fontForCalculateCellHeight 
                                                        constrainedToSize:CGSizeMake(288, 10000)].height;
                 model.totalHeight = model.contentHeight + 48;
             }
        }
        else
        {
            model.totalHeight = 44;
            model.contentStartPointX = titleWidth + titleContentMargin;
            model.cellType = CellTypeSingleLineMultiWordTitle;
        }
    }
    
    if(model.cellType == CellTypeCustomTags)
    {
        model.totalHeight = 44;
    }
    
    if(model.cellType == CellTypeAboutMeTitleAndImages)
    {
        model.contentHeight = 376;
        model.totalHeight = 376;
    }
	
	model.contentHeight = MAX(model.contentHeight, 13);
	model.totalHeight = MAX(model.totalHeight, 44);
	
	return [model autorelease];
}

- (DetailCellModel *)createTitleAndImageModel:(NSString *)title images:(NSArray *)imageArray
{
	DetailCellModel *model = [self createModelWithType:CellTypeTitleAndImages Title:nil contentText:title];
	model.photos = imageArray;
	model.hasAccessory = YES;
	model.totalHeight = 200;
	model.selectedResponse = CellSelectedResponseOpenInImageBrowser;
	
	return model;
}

- (DetailCellModel *)createTitleAndImageModelEx:(NSString *)title images:(NSArray *)imageArray
{
	DetailCellModel *model = [self createModelWithType:CellTypeTitleAndImages Title:nil contentText:title];
	model.images = imageArray;
	model.hasAccessory = YES;
	model.totalHeight = 200;
	model.selectedResponse = CellSelectedResponseOpenInImageBrowser;
	
	return model;
}

- (DetailCellModel *)createSummaryModel:(NSString *)summary
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineNoTitle Title:nil 
										   contentText:summary];
	return model;
}

- (DetailCellModel *)createOperationModel:(NSString *)operation
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLine4WordTitle Title:NSLocalizedString(@"開放時間:", @"DetailCellModel") 
										   contentText:operation];
	return model;
}

- (DetailCellModel *)createAvailableModel:(NSString *)available
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLine4WordTitle Title:NSLocalizedString(@"上架時間:", @"DetailCellModel") 
										   contentText:available];
	return model;
}

- (DetailCellModel *)createLocationPriceModel:(NSString *)price
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLine4WordTitle Title:NSLocalizedString(@"消費價位:", @"DetailCellModel") 
										   contentText:price];
	model.inRed = YES;
	return model;
}

- (DetailCellModel *)createProductPriceModel:(NSString *)price
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLine4WordTitle Title:NSLocalizedString(@"商品價錢:", @"DetailCellModel") 
										   contentText:[NSString stringWithFormat:NSLocalizedString(@"%@元", @"DetailCellModel"), price]];
	model.inRed = YES;
	return model;
}

- (DetailCellModel *)createAddressModel:(NSString *)name address:(NSString *)address lat:(NSNumber *)lat lon:(NSNumber *)lon
{
	DetailCellModel *model = [self createModelWithType:CellTypeAddressAndMap Title:name 
										   contentText:address];
	model.lat = [lat doubleValue];
	model.lon = [lon doubleValue];
	model.totalHeight = 70;
	model.hasAccessory = YES;
	model.selectedResponse = CellSelectedResponseOpenInMap;
	
	return model;
}

- (DetailCellModel *)createTelephoneModel:(NSString *)telephone
{
	NSString *processedTelephone = telephone;
    /*
	if([processedTelephone length])
	{
		// process telephone to add +886
		NSString *firstNumber = [telephone substringToIndex:1]; //up to, but not including, the one at anIndex
		
		if([firstNumber isEqualToString: @"0"] == YES)
			processedTelephone = [NSString stringWithFormat:@"+886%@", [telephone substringFromIndex:1]];
		else
			processedTelephone = [NSString stringWithFormat:@"+886%@",telephone];
	}
     */
	
	DetailCellModel *model = [self createModelWithType:CellTypeSingleLine2WordTitle Title:NSLocalizedString(@"電話:", @"DetailCellModel") 
										   contentText:processedTelephone];
	model.hasAccessory = YES;
	model.selectedResponse = CellSelectedResponseCall;
	
	return model;
}

- (DetailCellModel *)createWebUrlModel:(NSString *)url
{
	DetailCellModel *model = [self createModelWithType:CellTypeSingleLine2WordTitle Title:NSLocalizedString(@"網址:", @"DetailCellModel") 
										   contentText:url];
	model.hasAccessory = YES;
	model.selectedResponse = CellSelectedResponseOpenInSafari;
	
	return model;
}

- (DetailCellModel *)createAppPromoModel:(NSString *)appPromo
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLine4WordTitle Title:NSLocalizedString(@"App優惠:", @"DetailCellModel") 
										   contentText:appPromo];	
	return model;
}

- (DetailCellModel *)createRecipeDescModel:(NSString *)desc
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineStandAloneTitle Title:NSLocalizedString(@"主題說明:", @"DetailCellModel") 
										   contentText:desc];	
	return model;
}

- (DetailCellModel *)createProductDescModel:(NSString *)desc
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineStandAloneTitle Title:NSLocalizedString(@"商品說明:", @"DetailCellModel") 
										   contentText:desc];	
	return model;
}

- (DetailCellModel *)createLocationDescModel:(NSString *)desc
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineStandAloneTitle Title:NSLocalizedString(@"地點說明:", @"DetailCellModel") 
										   contentText:desc];	
	return model;
}

- (DetailCellModel *)createLocationDirectionModel:(NSString *)direction
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineStandAloneTitle Title:NSLocalizedString(@"交通資訊:", @"DetailCellModel") 
										   contentText:direction];	
	return model;
}

- (DetailCellModel *)createWaitingModel
{
	DetailCellModel *model = [self createModelWithType:CellTypeWaiting Title:@"" 
										   contentText:NSLocalizedString(@"讀取中...", @"DetailCellModel")];
	return model;
}

- (DetailCellModel *)createAboutMeDetailDesc:(NSString *)desc
{
	DetailCellModel *model = [self createModelWithType:CellTypeMultiLineStandAloneTitle Title:NSLocalizedString(@"關於我說明:", @"DetailCellModel") 
										   contentText:desc];	
	return model;
}

- (DetailCellModel *)createShareModel:(NSString *)optional
{
	DetailCellModel *model = [self createModelWithType:CellTypeSocialAndShare Title:NSLocalizedString(@"分享:", @"DetailCellModel") 
										   contentText:optional];
	model.hasAccessory = YES;
    model.selectedResponse = CellSelectedResponseSharing;
    //model.totalHeight = 55;
	return model;
}

- (DetailCellModel *)createCellTypeTitleAndImagesEnhancedModel:(NSString *)title images:(NSArray *)imageArray url:(NSString *)itemUrl phone:(NSString *)phoneNumber price:(NSNumber *)price salePrice:(NSNumber *)salePrice
{
    DetailCellModel *model = [self createModelWithType:CellTypeTitleAndImagesEnhanced Title:nil contentText:title];
	model.images = imageArray;
	//model.hasAccessory = NO;
	model.selectedResponse = CellSelectedResponseMultiPurpose;
    model.miscContents = [NSMutableDictionary dictionaryWithObjectsAndKeys: itemUrl, @"url",  phoneNumber, @"phoneNumber", price, @"price", salePrice, @"salePrice", nil];
    
    return model;
}

//************new method
- (DetailCellModel *)createCellTypeTitleAndImagesEnhancedModel:(NSString *)title images:(NSArray *)imageArray url:(NSString *)itemUrl phone:(NSString *)phoneNumber price:(NSNumber *)price salePrice:(NSNumber *)salePrice productId:(NSNumber *)productId
{
    DetailCellModel *model = [self createModelWithType:CellTypeTitleAndImagesEnhanced Title:nil contentText:title];
	model.images = imageArray;
	//model.hasAccessory = NO;
	model.selectedResponse = CellSelectedResponseMultiPurpose;
    model.miscContents = [NSMutableDictionary dictionaryWithObjectsAndKeys: itemUrl, @"url",  phoneNumber, @"phoneNumber", price, @"price", salePrice, @"salePrice", nil];
    model.productId=productId;
    
    return model;
}



- (DetailCellModel *)createCustomAttributeModel:(NSString *)aTitle contentText:(NSString *)aText
{
    DetailCellModel *model = [self createModelWithType:CellTypeCustomAttribute Title:aTitle contentText:aText];
    return model;
}

- (DetailCellModel *)createCustomTagModel:(NSArray *)anArray
{
    DetailCellModel *model = [self createModelWithType:CellTypeCustomTags Title:NSLocalizedString(@"商品屬性:", nil) contentText:nil];
    NSMutableDictionary *tagsInfo = [NSMutableDictionary dictionary];
    
    // calculate the height
    int numOfTags = [anArray count];
    int numOfLines = numOfTags / 3 + ((numOfTags % 3) == 0 ? 0 : 1);
    if(numOfTags > 3)
        model.totalHeight += (numOfLines - 1) * 26;
    
    [tagsInfo setObject:anArray forKey:@"tags"];
    [tagsInfo setObject:[NSNumber numberWithInt:numOfLines] forKey:@"numLines"];
    [tagsInfo setObject:[NSNumber numberWithInt:numOfTags] forKey:@"numTags"];
    
    model.miscContents = tagsInfo;
    
    return model;
}

- (DetailCellModel *)createAboutMeTitleModel:(NSString *)title images:(NSArray *)imageArray summary:(NSString *)itemSummary
{
    DetailCellModel *model = [self createModelWithType:CellTypeAboutMeTitleAndImages Title:title contentText:itemSummary];
    model.images = imageArray;
    return model;
}

- (DetailCellModel *)createRemarkModel:(NSString *)aMessage
{
    DetailCellModel *model = [self createModelWithType:CellTypeSingleLineCenterNoTitle Title:nil contentText:aMessage];
    return model;
}

- (DetailCellModel *)createEmailModel:(NSString *)anEmail
{
    DetailCellModel *model = [self createModelWithType:CellTypeSingleLine3WordTitle Title:@"Email:" contentText:anEmail];
    model.hasAccessory = YES;
    model.selectedResponse = CellSelectedResponseEmail;
    return model;
}

@end
