//
//  ThemeManager.m
//  tinysquare
//
//  Created by  on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeManager.h"
#import "NSString+JTGExt.h"
#import "ThemeObject.h"
#import "DictionaryHelper.h"

@interface ThemeManager()
- (void)loadDefaultTheme;
- (void)loadThemeBlue;
- (void)loadThemeRed;
- (void)loadThemeGray;
- (void)loadThemePink;
- (void)loadThemeGreen;
- (void)loadThemeLightGreen;
- (void)loadThemeSkyBlue;
- (void)loadThemeOrange;
- (void)loadThemePurple;
- (void)loadThemeBrown;
- (void)saveThemeSelection;
- (void)loadSavedThemeSelection;
@end

static ThemeManager* singletonManager = nil;

@implementation ThemeManager

#pragma mark - define

#define THEME_SELECTION                             @"themeSelection"

#define THEMEOBJECT                                 @"themeObject"
#define SEPARATOR                                   @","
#define STATUSBARSTYLE                              @"statusBarStyle"
#define COMMONBACKGROUNDIMAGE                       @"commonBackgroundImage"
#define TABBARLINE1                                 @"tabBarLine1"
#define TABBARLINE2                                 @"tabBarLine2"
#define TABBARLINE3                                 @"tabBarLine3"
#define TABBARBASECOLOR                             @"tabBarBaseColor"
#define TABBARBASEGRADIENTCOLORARRAY                @"tabBarBaseGradientColorArray"
#define TABBARHIGHLIGHTCOLOR                        @"tabBarHighlightColor"
#define TABBARHIGHLIGHTGRADIENTCOLORARRAY           @"tabBarHighlightGradientColorArray"
#define NAVIGATIONBARBGIMAGE                        @"navigationBarBgImage"
#define NAVIGATIONBARTITLETEXTCOLOR                 @"navigationBarTitleTextColor"
#define NAVIGATIONBARBACKBUTTONBGIMAGE              @"navigationBarBackButtonBgImage"
#define NAVIGATIONBARBUTTONBGIMAGE                  @"navigationBarButtonBgImage"
#define HOTPRODUCTBGIMAGE                           @"hotProductBgImage"
#define HOTPRODUCTLOADINGIMAGE                      @"hotProductLoadingImage"
#define HOTPRODUCTTEXTBG                            @"hotProductTextBg"
#define HOTPRODUCTPAGEDOTCOLORNORMAL                @"hotProductPageDotColorNormal"
#define HOTPRODUCTPAGEDOTCOLORACTIVE                @"hotProductPageDotColorActive"
#define HOTPRODUCTIMAGEBG                           @"hotProductImageBg"
#define DETAILVIEWBGIMAGE                           @"detailViewBgImage"
#define SEARCHBARIMAGE                              @"searchBarImage"
#define PRODUCTLISTBGIMAGE                          @"productListBgImage"
#define PRODUCTCELLBGCOLOR                          @"productCellBgColor"


#pragma mark - macro

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/100.0]

#pragma mark - synthesize

@synthesize selectedThemeIndex;
@synthesize themeArray;
@synthesize commonBgImageName;
@synthesize tabBarLine1;
@synthesize tabBarLine2;
@synthesize tabBarLine3;
@synthesize tabBarBaseColor;
@synthesize tabBarBaseGradientColorArray;
@synthesize tabBarHighlightColor;
@synthesize tabBarHighlightGradientColorArray;
@synthesize navigationBarBgImageName;
@synthesize navigationBarTitleTextColor;
@synthesize navigationBarBackButtonBgImageName;
@synthesize navigationBarButtonBgImageName;
@synthesize hotProductBgImageName;
@synthesize hotProductLoadingImageName;
@synthesize hotProductTextBg;
@synthesize hotProductPageDotNormal;
@synthesize hotProductPageDotActive;
@synthesize detailViewBgImageName;
@synthesize searchBarImageName;
@synthesize productListBgImageName;
@synthesize productCellBgColor;

@synthesize tabBarPadBaseColor;


#pragma mark - dealloc

- (void)dealloc {
    [themeArray release];
    [commonBgImageName release];
    [tabBarLine1 release];
    [tabBarLine2 release];
    [tabBarLine3 release];
    [tabBarBaseColor release];
    [tabBarBaseGradientColorArray release];
    [tabBarHighlightColor release];
    [tabBarHighlightGradientColorArray release];
    [navigationBarBgImageName release];
    [navigationBarTitleTextColor release];
    [navigationBarBackButtonBgImageName release];
    [navigationBarButtonBgImageName release];
    [hotProductBgImageName release];
    [hotProductLoadingImageName release];
    [hotProductTextBg release];
    [hotProductPageDotNormal release];
    [hotProductPageDotActive release];    
    [detailViewBgImageName release];
    [searchBarImageName release];
    [productListBgImageName release];
    [productCellBgColor release];
    
    [tabBarPadBaseColor release];
    
    [super dealloc];
}

#pragma mark - init

- (id)init {
    self = [super init];
    if (self) {
        themeArray = [[NSMutableArray array] retain];
        [self loadThemes];
        [self loadSavedThemeSelection];
        self.selectedThemeIndex = 0;
        [self setTheme:self.selectedThemeIndex fireNotification:NO];
    }
    return self;
}


#pragma mark - theme related methods

- (void)setTheme:(int)themeIndex fireNotification:(BOOL)flag
{
    NSDictionary *themeInfo = [self.themeArray objectAtIndex:themeIndex];
    
    // status bar style (apply it right here)
    if([[themeInfo stringForKey:STATUSBARSTYLE] isEqualToString:@"black"])
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    // common background
    self.commonBgImageName = [themeInfo stringForKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    self.tabBarLine1 = [[themeInfo objectForKey:TABBARLINE1] rgbCommaStringToUIColor];
    self.tabBarLine2 = [[themeInfo objectForKey:TABBARLINE2] rgbCommaStringToUIColor];
    self.tabBarLine3 = [[themeInfo objectForKey:TABBARLINE3] rgbCommaStringToUIColor];
    self.tabBarBaseColor = [[themeInfo objectForKey:TABBARBASECOLOR] rgbCommaStringToUIColor];
    self.tabBarBaseGradientColorArray = [[themeInfo objectForKey:TABBARBASEGRADIENTCOLORARRAY] componentsSeparatedByString:SEPARATOR];
    self.tabBarHighlightColor = [[themeInfo objectForKey:TABBARHIGHLIGHTCOLOR] rgbCommaStringToUIColor];
    self.tabBarHighlightGradientColorArray = [[themeInfo objectForKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY] componentsSeparatedByString:SEPARATOR];
    
    // navigation bar
    self.navigationBarBgImageName = [themeInfo stringForKey:NAVIGATIONBARBGIMAGE];
    self.navigationBarTitleTextColor = [[themeInfo stringForKey:NAVIGATIONBARTITLETEXTCOLOR] rgbCommaStringToUIColor];
    self.navigationBarBackButtonBgImageName = [themeInfo stringForKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    self.navigationBarButtonBgImageName = [themeInfo stringForKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // hot product
    self.hotProductBgImageName = [themeInfo stringForKey:HOTPRODUCTBGIMAGE];
    self.hotProductLoadingImageName = [themeInfo stringForKey:HOTPRODUCTLOADINGIMAGE];
    self.hotProductTextBg = [themeInfo stringForKey:HOTPRODUCTTEXTBG];
    self.hotProductPageDotNormal = [[themeInfo stringForKey:HOTPRODUCTPAGEDOTCOLORNORMAL] rgbCommaStringToUIColor];
    self.hotProductPageDotActive = [[themeInfo stringForKey:HOTPRODUCTPAGEDOTCOLORACTIVE] rgbCommaStringToUIColor];
    
    // detail view
    self.detailViewBgImageName = [themeInfo stringForKey:DETAILVIEWBGIMAGE];
    
    // product list and bookmark
    self.searchBarImageName = [themeInfo stringForKey:SEARCHBARIMAGE];
    self.productListBgImageName = [themeInfo stringForKey:PRODUCTLISTBGIMAGE];
    self.productCellBgColor = [[themeInfo stringForKey:PRODUCTCELLBGCOLOR] rgbCommaStringToUIColor];
    
    // iPad
    self.tabBarPadBaseColor = RGBA(248, 119, 24, 80);
    
    
    if(flag)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.5f 
                                         target:self 
                                       selector:@selector(broadcastNotificationForThemeChange:) userInfo:nil repeats:NO];
    }
    
    // save the setting to user default
    self.selectedThemeIndex = themeIndex;
    [self saveThemeSelection];
}

- (void)broadcastNotificationForThemeChange:(NSTimer *)timer
{
    NSNotification * themeChange = [NSNotification notificationWithName:@"com.fingertipcreative.tinysquare.themeChange" object:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:themeChange postingStyle:NSPostWhenIdle];
}

- (void)saveThemeSelection
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedThemeIndex forKey:THEME_SELECTION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadSavedThemeSelection
{
    self.selectedThemeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:THEME_SELECTION];
}

- (NSArray *)getListOfThemes
{
    /*
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadThemes];
    });
     */
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *themeInfo in self.themeArray)
    {
        [array addObject:[themeInfo objectForKey:THEMEOBJECT]];
    }
    return array;
}

- (void)loadThemes
{
    [self loadDefaultTheme];
    [self loadThemeBlue];
    [self loadThemeRed];
    [self loadThemeGray];
    [self loadThemePink];
    
    [self loadThemeGreen];
    [self loadThemeLightGreen];
    [self loadThemeOrange];
    [self loadThemePurple];
    [self loadThemeSkyBlue];
    [self loadThemeBrown];
}

- (void)loadDefaultTheme
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Default";
    themeObject.themeColor = RGB(255,103,20);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                                 forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgDefault.png"                     forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"130,130,130"                             forKey:TABBARLINE1];
    [themeInfo setObject:@"199,199,199"                             forKey:TABBARLINE2];
    [themeInfo setObject:@"165,165,165"                             forKey:TABBARLINE3];
    
    [themeInfo setObject:@"121,121,121"                             forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"156,156,156,135,135,135"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"252,112,36"                              forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"252,112,36,252,125,54"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgDefault.png"              forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"0,0,0"                                   forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgDefault.png"    forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgDefault.png"        forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgDefault.png"                 forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageDefault.png"       forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"             forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                             forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"255,103,20"                              forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgDefault.png"                 forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageDefault.png"               forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgDefault.png"                forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"255,255,255"                             forKey:PRODUCTCELLBGCOLOR];
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeBlue
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Blue";
    themeObject.themeColor = RGB(74,101,129);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgBlue.png"                    forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"32,50,68"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"63,91,120"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"54,81,108"                           forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"74,106,138,70,97,125"                forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"13,41,70"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"27,53,80,22,48,76"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgBlue.png"             forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgBlue.png"   forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgBlue.png"       forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgBlue.png"                forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageBlue.png"      forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"74,101,129"                          forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgBlue.png"                forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageBlue.png"              forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgBlue.png"               forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"252,252,250"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeRed
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Red";
    themeObject.themeColor = RGB(196,0,0);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"black"                               forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgRed.png"                     forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"138,26,26"                           forKey:TABBARLINE2];
    [themeInfo setObject:@"184,15,25"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"180,0,0"                             forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"221,15,15,217,9,9"                   forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"132,11,11"                           forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"137,26,26,135,20,20"                 forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgRed.png"              forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgRed.png"    forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgRed.png"        forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgRed.png"                 forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageRed.png"       forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"196,0,0"                             forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgRed.png"                 forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageRed.png"               forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgRed.png"                forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"251,249,246"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeGray
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Gray";
    themeObject.themeColor = RGB(86,86,86);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"black"                               forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgGray.png"                    forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"210,210,210"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"75,75,75"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"92,92,92"                            forKey:TABBARLINE3];
    
    [themeInfo setObject:@"65,65,65"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"83,83,83,86,86,86"                   forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"45,45,45"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"57,57,57,56,56,56"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgGray.png"             forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgGray.png"   forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgGray.png"       forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgGray.png"                forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageGray.png"      forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"86,86,86"                            forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgGray.png"                forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageGray.png"              forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgGray.png"               forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"237,237,239"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemePink
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Pink";
    themeObject.themeColor = RGB(195,49,89);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgPink.png"                    forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"216,74,127"                          forKey:TABBARLINE2];
    [themeInfo setObject:@"240,87,154"                          forKey:TABBARLINE3];
    
    [themeInfo setObject:@"230,41,115"                          forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"245,78,150,235,57,140"               forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"182,27,63"                           forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"203,53,91,194,48,88"                 forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgPink.png"             forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgPink.png"   forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgPink.png"       forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgPink.png"                forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImagePink.png"      forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"195,49,89"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgPink.png"                forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImagePink.png"              forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgPink.png"               forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"251,249,246"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeGreen
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Green";
    themeObject.themeColor = RGB(74,129,86);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgGreen.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"27,80,38"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"47,112,58"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"20,97,33"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"35,111,47,37,121,51"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"13,70,25"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"27,80,38,27,80,38"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgGreen.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgGreen.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgGreen.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgGreen.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageGreen.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"74,129,86"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgGreen.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageGreen.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgGreen.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"252,252,250"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeLightGreen
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Light Green";
    themeObject.themeColor = RGB(50,140,1);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgLightGreen.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"0,86,20"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"126,204,108"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"7,127,28"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"83,176,37,5,132,26"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"9,88,1"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"39,134,2,19,108,1"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgLightGreen.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgLightGreen.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgLightGreen.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgLightGreen.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageLightGreen.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"50,140,1"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgLightGreen.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageLightGreen.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgLightGreen.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"246,244,237"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeSkyBlue
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Sky Blue";
    themeObject.themeColor = RGB(21,188,218);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgSkyBlue.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"17,138,207"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"164,241,252"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"1,155,205"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"68,202,246,2,170,218"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"1,99,155"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"1,137,194,2,108,163"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgSkyBlue.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgSkyBlue.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgSkyBlue.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgSkyBlue.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageSkyBlue.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"21,188,218"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgSkyBlue.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageSkyBlue.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgSkyBlue.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"249,251,250"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeOrange
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Orange";
    themeObject.themeColor = RGB(221,56,18);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgOrange.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"180,97,17"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"239,133,44"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"247,121,16"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"248,148,19,244,151,32"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"236,68,33"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"236,81,47,230,74,42"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgOrange.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgOrange.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgOrange.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgOrange.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageOrange.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"221,56,18"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgOrange.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageOrange.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgOrange.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"251,249,246"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemePurple
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Purple";
    themeObject.themeColor = RGB(84,74,133);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"default"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgPurple.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"54,43,109"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"102,93,147"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"63,54,108"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"85,74,138,80,70,125"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"25,15,82"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"39,29,91,39,29,91"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgPurple.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgPurple.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgPurple.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgPurple.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImagePurple.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"84,74,133"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgPurple.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImagePurple.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgPurple.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"252,252,250"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}

- (void)loadThemeBrown
{
    NSMutableDictionary *themeInfo = [NSMutableDictionary dictionary];
    
    // theme object
    ThemeObject *themeObject = [[ThemeObject alloc] init];
    themeObject.themeName = @"Brown";
    themeObject.themeColor = RGB(108,79,78);
    themeObject.themeIndex = [self.themeArray count];
    [themeInfo setObject:themeObject forKey:THEMEOBJECT];
    [themeObject release];
    
    // status bar
    [themeInfo setObject:@"black"                             forKey:STATUSBARSTYLE];
    
    // common background
    [themeInfo setObject:@"commonBgBrown.png"                   forKey:COMMONBACKGROUNDIMAGE];
    
    // tab bar
    [themeInfo setObject:@"255,255,255"                         forKey:TABBARLINE1];
    [themeInfo setObject:@"147,80,34"                            forKey:TABBARLINE2];
    [themeInfo setObject:@"167,83,53"                           forKey:TABBARLINE3];
    
    [themeInfo setObject:@"118,50,14"                            forKey:TABBARBASECOLOR];
    [themeInfo setObject:@"167,83,53,130,61,25"                 forKey:TABBARBASEGRADIENTCOLORARRAY];
    
    [themeInfo setObject:@"83,22,1"                            forKey:TABBARHIGHLIGHTCOLOR];
    [themeInfo setObject:@"110,48,17,96,37,16"                   forKey:TABBARHIGHLIGHTGRADIENTCOLORARRAY];
    
    // navigation bar
    [themeInfo setObject:@"navigationBarBgBrown.png"            forKey:NAVIGATIONBARBGIMAGE];
    [themeInfo setObject:@"255,255,255"                         forKey:NAVIGATIONBARTITLETEXTCOLOR];
    [themeInfo setObject:@"navigationBarBackButtonBgBrown.png"  forKey:NAVIGATIONBARBACKBUTTONBGIMAGE];
    [themeInfo setObject:@"navigationBarButtonBgBrown.png"      forKey:NAVIGATIONBARBUTTONBGIMAGE];
    
    // whats hot
    [themeInfo setObject:@"hotProductBgBrown.png"               forKey:HOTPRODUCTBGIMAGE];
    [themeInfo setObject:@"hotProductLoadingImageBrown.png"     forKey:HOTPRODUCTLOADINGIMAGE];
    [themeInfo setObject:@"hotProductTextBgDefault.png"         forKey:HOTPRODUCTTEXTBG];
    [themeInfo setObject:@"178,178,178"                         forKey:HOTPRODUCTPAGEDOTCOLORNORMAL];
    [themeInfo setObject:@"127,74,45"                           forKey:HOTPRODUCTPAGEDOTCOLORACTIVE];
    
    // detail view
    [themeInfo setObject:@"detailViewBgBrown.png"               forKey:DETAILVIEWBGIMAGE];
    
    // product list
    [themeInfo setObject:@"searchBarImageBrown.png"             forKey:SEARCHBARIMAGE];
    [themeInfo setObject:@"productListBgBrown.png"              forKey:PRODUCTLISTBGIMAGE];
    [themeInfo setObject:@"251,249,246"                         forKey:PRODUCTCELLBGCOLOR];
    
    
    // add to the theme array
    [self.themeArray addObject:themeInfo];
}


#pragma mark -
#pragma mark singleton implementation code

+ (ThemeManager *)sharedInstance {
	static dispatch_once_t pred;
	static ThemeManager *manager;
	
	dispatch_once(&pred, ^{ 
		manager = [[self alloc] init]; 
	});
	return manager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end