//
//  BrandReviewVC.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/31/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "BrandReviewVC.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "CategoryVC.h"
#import "WebViewVC.h"
#import "AccordionView.h"
#import "MappingFinder.h"
#import "GlobalVars.h"
#import "Tools.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NavigationManager.h"

@interface BrandReviewVC(){
    GlobalVars *globals;
    float firstTabHeight;
    float secondTabHeight;
    float thirdTabHeight;
    float accordionHeight;
}


@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIView *accordionView;
@property (weak, nonatomic) IBOutlet UIView *firstTabView;
@property (weak, nonatomic) IBOutlet UIView *secondTabView;
@property (weak, nonatomic) IBOutlet UIView *thirdTabView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seconTabWebViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tosImagesStackViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accordionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tosWysiwygHeightConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *secondTabWebView;
@property (weak, nonatomic) IBOutlet UIWebView *firstWysiwyg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWysiwygHeightConst;
@property (weak, nonatomic) IBOutlet UIStackView *carouselStackView;
@property (weak, nonatomic) IBOutlet UIImageView *firstScreenShotPlaceholder;
@property (weak, nonatomic) IBOutlet UIScrollView *screenShotsCarousel;
@property (weak, nonatomic) IBOutlet UIView *tosPartView;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteValue;
@property (weak, nonatomic) IBOutlet UILabel *softwareProvidersLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeSinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeSinceValue;
@property (weak, nonatomic) IBOutlet UIImageView *bannerLogo;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportValue;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UIButton *claimButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTabHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTabHeightConst;

//bottom view of the third tab's view
@property (weak, nonatomic) IBOutlet UIView *thirdsBottomView;
@property (weak, nonatomic) IBOutlet UIWebView *tosWV;

@end

@implementation BrandReviewVC{

    //will be passed to navigation manager with a tag, so we heve the tag-url relation
    NSMutableDictionary *_tags2URLs;
    NSMutableArray * accordionWVArray;
    AccordionView *accordion;
    NavigationManager *_nav;
    NSArray *paymentMethodsImageViewsArray;
    NSArray *softwareProvidersImageViewsArray;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationRequestFromAppDel:) name:@"navigationRequestFromAppDel" object:Nil];
    globals = [GlobalVars sharedInstance];
    accordionHeight = 900;
    //Just add the imageviews to an array,to iterate later
    paymentMethodsImageViewsArray = [NSArray arrayWithObjects:_paymentMethodImgV1, _paymentMethodImgV2, _paymentMethodImgV3, _paymentMethodImgV4, _paymentMethodImgV5, _paymentMethodImgV6, _paymentMethodImgV7, _paymentMethodImgV8, _paymentMethodImgV9, nil];
    softwareProvidersImageViewsArray = [NSArray arrayWithObjects:_swProviderImgV1, _swProviderImgV2, _swProviderImgV3, _swProviderImgV4, nil];
    
    //    self.tabBar.selectedItem= self.tabBar.items[0];
    //for the menu
    _nav = [[NavigationManager alloc] init];
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    
    [self initBrandName];
    [self initBonus];
    [self initSegmentViews];
    [self initAccordionView];
    [self initClaimButton];
    [self initBannerLogo];
    [self initGeneralRating];
    [self initSecondTabWebView];
    [self initSomeUI];
    [self initFirstWysiwyg];
    [self initPaymentMethods];
    [self initSoftwareProviders];
    [self initSegmentText];
    [self initScreenshots];
    [self initLabelsValues];
    [self initTOSWV];
    [self initTosBottomImages];
    
}


//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewDidAppear:(BOOL)animated{
    //otherwise items are added on page reload (after failed share action)
    if([[_tabbar items] count] == 0)
        [self initTabBar];
    [self setActiveTabbarItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableMenuUserInteraction" object:Nil userInfo:nil];
}

//Google app indexing
-(void)navigationRequestFromAppDel:(NSNotification*)aNotif
{
    NSLog(@"BrandRev got notif");
    NSString *urlFromNotification=[[aNotif userInfo] objectForKey:@"urlToLoad"];
    [_nav navigateWithItemID:-42 WithURL:urlFromNotification WithURLsDict:nil WithSourceVC:self WithInitializedDestPP:nil];
}


// Some general page UI
-(void)initSomeUI{
    //borders
    _thirdsBottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _thirdsBottomView.layer.borderWidth = 0.5f;
    _tosPartView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tosPartView.layer.borderWidth = 0.5f;
    
}


- (IBAction)claimButtonAction:(id)sender {
    NSString *claimUrl = [_pp brandReviewGetAffiliateURL];
    [_nav navigateToAffLink:claimUrl];
}


-(void)initFirstWysiwyg{
    NSString *fontSize = @"3.8vw";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if([self isDeviceIPad]){
        fontSize = @"2.5vw";
    }
    NSString *urlString = [self.pp brandReviewGetWysiwyg];
    NSString *style = [Tools getDefaultWysiwygCSSFontSize:fontSize];
    [_firstWysiwyg loadHTMLString:[NSString stringWithFormat:@"%@<span>%@</span>",style,urlString] baseURL:nil];
}

-(void)initSegmentText{
    
    CGFloat fontSize = 14.0f;
    if([self isDeviceIPad])
        fontSize = 23.0f;
        
    UIFont *font = [UIFont fontWithName:@"Montserrat" size:fontSize];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_segment setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    NSArray *ar = [_pp brandReviewGetSegmentText];
    [_segment setTitle:ar[0] forSegmentAtIndex:0];
    [_segment setTitle:ar[1] forSegmentAtIndex:1];
    [_segment setTitle:ar[2] forSegmentAtIndex:2];
}


-(void)initBrandName{
    _brandNameLabel.text = [_pp brandReviewGetBrandName];
    _brandNameLabel.numberOfLines = 1;
    _brandNameLabel.minimumScaleFactor = 0.5;
    _brandNameLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)initBonus{
    _bonusLabel.text = [_pp brandReviewGetBonusText];
    _bonusLabel.numberOfLines = 1;
    _bonusLabel.minimumScaleFactor = 0.5;
    _bonusLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)initClaimButton{
    [_claimButton setTitle:[_pp brandNameGetClaimButtonText] forState:UIControlStateNormal];
    _claimButton.titleLabel.numberOfLines = 1;
    _claimButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _claimButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

-(void)initBannerLogo{
    NSURL *imgURL = [NSURL URLWithString:[_pp brandReviewGetBrandLogo]];
    [_bannerLogo sd_setImageWithURL:imgURL];
    _bannerLogo.bounds = CGRectInset(_bannerLogo.frame, 10.0f, 10.0f);
}

-(void)initGeneralRating{
    [_ratingImage setImage:[UIImage imageNamed:[[NSString stringWithFormat:@"rating%@",[_pp brandReviewGetBrandRating]] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]];
    
    _ratingImage.image = [_ratingImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_ratingImage setTintColor:[UIColor colorWithRed:245/255.0 green:242/255.0 blue:249/255.0 alpha:1]];
}

-(void)initLabelsValues{
    NSDictionary *dict = [_pp brandReviewGetBasicBrandInfoDict];
    _websiteLabel.text = [NSString stringWithFormat:@"%@: ",[dict valueForKey:@"website_key"]];
    
    NSMutableAttributedString *webValueAttributeString = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"website_value"]];
    
    [webValueAttributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[webValueAttributeString length]}];
    
    _websiteValue.attributedText = webValueAttributeString;
    _softwareProvidersLabel.text = [NSString stringWithFormat:@"%@: ",[dict valueForKey:@"software_key"]];
    _activeSinceLabel.text = [NSString stringWithFormat:@"%@: ",[dict valueForKey:@"active_since_key"]];
    _activeSinceValue.text = [dict valueForKey:@"active_since_value"];
    _supportLabel.text = [NSString stringWithFormat:@"%@: ",[dict valueForKey:@"support_key"]];
    
    NSMutableAttributedString *supValueAttributeString = [[NSMutableAttributedString alloc] initWithString:[dict valueForKey:@"support_value"]];
    [supValueAttributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[supValueAttributeString length]}];
    _supportValue.attributedText = supValueAttributeString;
    _paymentMethodsLabel.text = [NSString stringWithFormat:@"%@: ",[dict valueForKey:@"payment_key"]];
}

-(void)initPaymentMethods {
    NSArray *methodsArr = [self.pp brandReviewGetPaymentMethods];
    
    for (int i = 0; i < methodsArr.count; i++) {
        if(i == 9)
            break;
        UIImageView *currentIV = paymentMethodsImageViewsArray[i];
        CGRect frame = CGRectMake(currentIV.frame.origin.x, currentIV.frame.origin.y, 34, 20);
        currentIV.frame = frame;
        [currentIV sd_setImageWithURL:methodsArr[i]];
    }
}


-(void)initSoftwareProviders{
    NSArray *providers = [self.pp brandReviewGetSoftwareProviders];
    for (int i = 0; i < providers.count; i++) {
        //lets take max 3 now
        if(i == 3)
            break;
        UIImageView *currentIV = softwareProvidersImageViewsArray[i];
        CGRect frame = CGRectMake(currentIV.frame.origin.x, currentIV.frame.origin.y, 34, 20);
        currentIV.frame = frame;
        [currentIV sd_setImageWithURL:providers[i]];
    }
}


-(void)initTosBottomImages{
    //scoped out for now
    _tosImagesStackViewHeightConstraint.constant = 0;
//    NSArray *providers = [self.pp brandReviewGetSoftwareProviders];
//    [_bottomBrandInfoImgV1 sd_setImageWithURL:providers[0]];
//    [_bottomBrandInfoImgV2 sd_setImageWithURL:providers[1]];
//    [_bottomBrandInfoImgV3 sd_setImageWithURL:providers[2]];
}

-(void)initTOSWV{
    /*
    _tosWV.scrollView.scrollEnabled = NO;
    NSString *urlString = [self.pp brandReviewGetTOSWysiwyg];
    NSString *fontSize = @"3.8vw";
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if([self isDeviceIPad]){
        fontSize = @"2.5vw";
    }
    
    NSString *style = [Tools getDefaultWysiwygCSSFontSize:fontSize];
    urlString = [NSString stringWithFormat:@"%@<span>%@</span>", style,urlString];
    [_tosWV loadHTMLString:urlString baseURL:nil];
     */
    thirdTabHeight = 500;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(webView.tag == 14){
        CGRect frame = _firstWysiwyg.frame;
        frame.size.height = 1;
        _firstWysiwyg.frame = frame;
        CGSize fittingSize = [_firstWysiwyg sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _firstWysiwyg.frame = frame;
        _firstWysiwygHeightConst.constant = frame.size.height;
        _firstTabHeightConst.constant = _firstWysiwygHeightConst.constant + accordionHeight;
        
        firstTabHeight = _firstTabHeightConst.constant;
    }else if (webView.tag == 15){
        CGRect frame = _tosWV.frame;
        frame.size.height = 1;
        _tosWV.frame = frame;
        CGSize fittingSize = [_tosWV sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _tosWV.frame = frame;
        _tosWysiwygHeightConstraint.constant = frame.size.height;
    }else{
        //for the accordion
        NSLog(@"enter finishload for  : %ld", (long)webView.tag);
        //get best fitting size
        CGSize fittingSize = [webView sizeThatFits:CGSizeMake(webView.superview.frame.size.width, 1)];
        [webView.scrollView setScrollEnabled:NO];
        //init a new frame (with just another one)
        CGRect newFrame = webView.frame;
        //give the newFrame the fitting size
        newFrame.size = fittingSize;
        //set newFrame for the wv
        webView.frame = newFrame;
        
        //for seconTabWebView
        if(webView.tag == 20){
            NSLog(@"frame height %f",webView.frame.size.height);
            _seconTabWebViewHeightConstraint.constant = webView.frame.size.height + 20;
            _secondTabHeightConst.constant = _seconTabWebViewHeightConstraint.constant + 10;
            secondTabHeight = _seconTabWebViewHeightConstraint.constant;
            
        }
    }
}

-(void)initScreenshots{
    NSMutableArray *screenshots = [self.pp getBrandReviewScreenshots];
    [_firstScreenShotPlaceholder sd_setImageWithURL:screenshots[0]];
    for(int i = 1; i< screenshots.count; i++){
        UIImageView * imV;
        imV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_carouselStackView addArrangedSubview:imV];
        [imV  sd_setImageWithURL:screenshots[i]];
    }
}

-(void)initSegmentViews{
    _firstTabView.hidden=NO;
    _secondTabView.hidden=YES;
    _thirdTabView.hidden=YES;
}


-(void)initAccordionView{
    
    NSArray *ratingDetails = [_pp brandReviewGetRatingDetails];
    //widths : 6sPlus - 414, 6s - 375, ipad air and air 2, retina - 768,ipad pro 12.9inch - 1024, 5s and 7 SE - 320
    
    NSString *fontSize = @"3.8vw";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if([self isDeviceIPad]){
        fontSize = @"2.5vw";
    }
    
    
    accordionWVArray = [NSMutableArray array];
    
    CGFloat accordionWidth = self.view.frame.size.width;
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, accordionWidth, accordionHeight)];
    [self.accordionView addSubview:accordion];
    self.accordionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
    
    for(int i = 0 ; i< ratingDetails.count ; i++){
        
//        float rating = 3.5;
//        rating *=10;
//        NSString *filename= [NSString stringWithFormat:@"rating%.0fup",rating];
//        NSLog(@" filename %@",filename);
        // Only height is taken into account, so other parameters are just dummy
        CGFloat accordionHeadersHeight = 40;
        if([self isDeviceIPad]){
            accordionHeadersHeight = 50;
        }
        UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, accordionHeadersHeight)];
        
        
        //otherwise stringwithFormat writes (null) cause last elements has no rating title
//        if(i != ratingDetails.count-1)
        [header1 setTitle:[NSString stringWithFormat:@" %@",[ratingDetails[i] valueForKey:@"app_rating_title"]] forState:UIControlStateNormal];
        
        //border on top of the buttons
        UIView *border = [UIView new];
        border.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        border.frame = CGRectMake(0, 0, header1.frame.size.width, 1.0f);
        [header1 addSubview:border];
        
        UIImageView *ratingImgView;
        UIImageView *buttonImgView;
        CGFloat ratingImageX;
        CGFloat ratingImageWidth = 80;
        CGFloat buttonImgX;
        CGFloat buttonImgWidth = 20;
        
        buttonImgX = screenWidth - (buttonImgWidth + 5);
        ratingImageX = buttonImgX - (ratingImageWidth +10);
        
        [header1.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:17.0]];
        if(screenWidth > 444){
            [header1.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:22.0]];
            
            buttonImgX = screenWidth - (buttonImgWidth + 42);
            ratingImageX = buttonImgX - (ratingImageWidth + 42);
        }
        
        if([self isDeviceIPad]){
            ratingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ratingImageX, 4, ratingImageWidth * 1.3, accordionHeadersHeight - 4)];
        }else{
            ratingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ratingImageX, 10, ratingImageWidth, 20)];
        }
        [header1 addSubview:ratingImgView];
        [ratingImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating%@", [ratingDetails[i] valueForKey:@"app_rating"]]]];
        [ratingImgView setContentMode:UIViewContentModeScaleAspectFit];
        ratingImgView.image = [ratingImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [ratingImgView setTintColor:[UIColor colorWithRed:59/255.0 green:58/255.0 blue:71/255.0 alpha:1]];
        
        if([self isDeviceIPad]){
            buttonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonImgX, 8, buttonImgWidth * 1.7, accordionHeadersHeight - 16)];
        }else{
            buttonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonImgX, 10, buttonImgWidth, 20)];
        }
        [header1 addSubview:buttonImgView];
        [buttonImgView setImage:[UIImage imageNamed:@"arrow_down"]];
        buttonImgView.image = [buttonImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [buttonImgView setTintColor:[UIColor colorWithRed:146/255.0 green:142/255.0 blue:169/255.0 alpha:1]];
        
        
        [buttonImgView setContentMode:UIViewContentModeScaleAspectFit];
        buttonImgView.tag = 10;
        
        //if first element, we rotate the image, as tab is open.
        if(i == 0){
            UIImage *rotated = [self upsideDownBunny:M_PI withImage:buttonImgView.image];
            buttonImgView.image = rotated;
        }
        
        //if last element, we rotate it 90
        if(i == ratingDetails.count-1){
            UIImage *rotated = [self upsideDownBunny:-M_PI/2 withImage:buttonImgView.image];
            buttonImgView.image = rotated;
            //avoid rotating on click
            buttonImgView.tag = 11;
            [buttonImgView setTintColor:[UIColor redColor]];
            [buttonImgView setTintColor:[UIColor colorWithRed:205/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
            [ratingImgView setTintColor:[UIColor whiteColor]];
            [buttonImgView setBackgroundColor:[UIColor whiteColor]];
        }
        
        header1.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        header1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        header1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
        [header1 setTitleColor:[UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:1.000] forState:UIControlStateNormal];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
        view1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
        
        [accordion addHeader:header1 withView:view1];
        view1.tag = 3*i;
        
        
        //if not last element
        if(i != ratingDetails.count-1){
            
            UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, accordionWidth, 1)];
            wv.delegate = self;
            wv.tag = i;
            //disable scrolling in webview
            [[wv scrollView] setScrollEnabled:NO];
            //disable background color in webview
            [wv setBackgroundColor:[UIColor clearColor]];
            [wv setOpaque:NO];
            [header1 addTarget:self action:@selector(changeAccordionArrowOrientation:) forControlEvents:UIControlEventTouchUpInside];
            NSString *htmlString = [NSString stringWithFormat:@"%@<span>%@</span>",[Tools getDefaultWysiwygCSSFontSize:fontSize],[ratingDetails[i] valueForKey:@"app_rating_description"]];
            [view1 addSubview:wv];
            [wv loadHTMLString:htmlString baseURL:nil];
            [accordionWVArray addObject:wv];
            
        }else{
            //if last element
            header1.backgroundColor = [UIColor colorWithRed:76/255.0 green:75/255.0 blue:89/255.0 alpha:1];
            [header1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [header1 addTarget:self action:@selector(openBrandAffLink) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }

    [accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [accordion setAllowsEmptySelection:YES];
}

//downloaded code for changing image orientation
- (UIImage*)upsideDownBunny:(CGFloat)radians withImage:(UIImage*)testImage {
    __block CGImageRef cgImg;
    __block CGSize imgSize;
    __block UIImageOrientation orientation;
    dispatch_block_t createStartImgBlock = ^(void) {
        // UIImages should only be accessed from the main thread
        
        UIImage *img =testImage;
        imgSize = [img size]; // this size will be pre rotated
        orientation = [img imageOrientation];
        cgImg = CGImageRetain([img CGImage]); // this data is not rotated
        
    };
    if([NSThread isMainThread]) {
        createStartImgBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), createStartImgBlock);
    }
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    // in iOS4+ you can let the context allocate memory by passing NULL
    CGContextRef context = CGBitmapContextCreate( NULL,
                                                 imgSize.width,
                                                 imgSize.height,
                                                 8,
                                                 imgSize.width * 4,
                                                 colorspace,
                                                 kCGImageAlphaPremultipliedLast);
    // rotate so the image respects the original UIImage's orientation
    switch (orientation) {
        case UIImageOrientationDown:
            CGContextTranslateCTM(context, imgSize.width, imgSize.height);
            CGContextRotateCTM(context, -radians);
            break;
        case UIImageOrientationLeft:
            CGContextTranslateCTM(context, 0.0, imgSize.height);
            CGContextRotateCTM(context, 3.0 * -radians / 2.0);
            break;
        case UIImageOrientationRight:
            CGContextTranslateCTM(context,imgSize.width, 0.0);
            CGContextRotateCTM(context, -radians / 2.0);
            break;
        default:
            // there are mirrored modes possible
            // but they aren't generated by the iPhone's camera
            break;
    }
    // rotate the image upside down
    
    CGContextTranslateCTM(context, +(imgSize.width * 0.5f), +(imgSize.height * 0.5f));
    CGContextRotateCTM(context, -radians);
    //CGContextDrawImage( context, CGRectMake(0.0, 0.0, imgSize.width, imgSize.height), cgImg );
    CGContextDrawImage(context, (CGRect){.origin.x = -imgSize.width* 0.5f , .origin.y = -imgSize.width* 0.5f , .size.width = imgSize.width, .size.height = imgSize.width}, cgImg);
    // grab the new rotated image
    CGContextFlush(context);
    CGImageRef newCgImg = CGBitmapContextCreateImage(context);
    __block UIImage *newImage;
    dispatch_block_t createRotatedImgBlock = ^(void) {
        // UIImages should only be accessed from the main thread
        newImage = [UIImage imageWithCGImage:newCgImg];
        newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    };
    if([NSThread isMainThread]) {
        createRotatedImgBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), createRotatedImgBlock);
    }
    CGColorSpaceRelease(colorspace);
    CGImageRelease(newCgImg);
    CGContextRelease(context);
    return newImage;
}


// will rotate by 180
-(void)changeAccordionArrowOrientation:(id) sender{
    UIButton *button = (UIButton *) sender;
    for (UIView *i in button.subviews){
        if([i isKindOfClass:[UIImageView class]]){
            UIImageView *imgV = (UIImageView *)i;
            if(imgV.tag == 10){
                UIImage *rotated = [self upsideDownBunny:M_PI withImage:imgV.image];
                [rotated imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                imgV.image = rotated;
            }
        }
    }
}

-(void)openBrandAffLink{
    [_nav navigateToAffLink:[_pp brandReviewGetAffiliateURL]];
}


-(void)initSecondTabWebView{
    [_secondTabWebView setBackgroundColor:[UIColor clearColor]];
    [_secondTabWebView setOpaque:NO];
    _secondTabWebView.scrollView.scrollEnabled = NO;
    
    _secondTabWebView.tag = 20;
    NSString *fontSize = @"3.8vw";
    
    if([self isDeviceIPad]){
        fontSize = @"2.5vw";
    }
    
    NSString *htmlString = [self.pp brandReviewGetSecondTabWysiwyg];
    if(htmlString.length < 8){
        [self setConstraintZeroToView:_secondTabWebView];
    }else{
        htmlString = [NSString stringWithFormat:@"%@<span>%@</spann>",[Tools getDefaultWysiwygCSSFontSize:fontSize],htmlString];
        [_secondTabWebView loadHTMLString:htmlString baseURL:nil];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //open page from wysiwyg
    NSString *urlString = [[request URL] absoluteString];
    
    //if url contains "online-casinoes-canada.ca" && url NOT contains "links", then it's app page.
    if([urlString containsString:[[GlobalVars sharedInstance] websiteURL]] &&  ! [urlString containsString:globals.redirectionTrigger]){
        [_nav navigateWithItemID:-42 WithURL:urlString WithURLsDict:nil WithSourceVC:self WithInitializedDestPP:nil];
        return NO;
    }
    
    //if url contains "online-casinoes-canada.ca" && url contains "links", then it's an aff link.
    if (([urlString containsString:[[GlobalVars sharedInstance] websiteURL]] && [urlString containsString:globals.redirectionTrigger])) {
        [_nav navigateToAffLink:urlString];
        return NO;
    }
    return YES;
}



- (IBAction)segmentValueChanged:(id)sender {
    
    CGRect frame = _thirdTabView.frame;
    CGSize fittingSize = [_thirdTabView sizeThatFits:_thirdTabView.frame.size];
    frame.size = fittingSize;
    switch (_segment.selectedSegmentIndex) {
        case 0:
            _secondTabView.hidden=YES;
            _thirdTabView.hidden=YES;
            _firstTabView.hidden=NO;
            _firstTabHeightConst.constant = firstTabHeight;
            break;
        case 1:
            _firstTabView.hidden=YES;
            _thirdTabView.hidden=YES;
            _secondTabView.hidden=NO;
            _firstTabHeightConst.constant = secondTabHeight;
            break;
            
        case 2:
            _firstTabView.hidden=YES;
            _secondTabView.hidden=YES;
            _thirdTabView.hidden=NO;
            _firstTabHeightConst.constant = thirdTabHeight;
            break;
            
        default:
            //default show 0
            break;
    }
}


//Handle tabBar clicks
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 42){
        [self.revealViewController rightRevealToggle:self];
    }else if(item.tag == 84){
        [self handleSharingEvent];
    }
    else if(item.tag == _activeTab){
        return;
    }else{
        [_nav navigateWithItemID:item.tag WithURL:nil WithURLsDict:_tags2URLs WithSourceVC:self WithInitializedDestPP:nil];
    }
}

//Sharing
-(void)handleSharingEvent{
    // create a message
    NSString *urlToShare = _pp.pageURL;
    //    NSArray *items = @[theMessage, [UIImage imageNamed:@"betwaylogo"]];
    NSArray *items = @[urlToShare];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
    NSLog(@"Share it !");
}
- (void)presentActivityController:(UIActivityViewController *)controller {
    
    if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        controller.popoverPresentationController.sourceView = self.view;
    }
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
        } else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

-(void)initTabBar{
    _tags2URLs = [[NSMutableDictionary alloc] init];
    NSMutableArray *tabBarArray;
    int i;
    self.tabbarElements = [self.pp getTabBarElements];
    tabBarArray = [[NSMutableArray alloc] init];
    UITabBarItem *homeItem;
    UITabBarItem *menuItem;
    UITabBarItem *shareItem;
    
    //set middle items
    //Homepage and menu position in the json array doesnt matter, for the others it does.
    for(i = 0; i < self.tabbarElements.count; i++){
        NSDictionary *tabbarDict = self.tabbarElements[i];
        UIImage * iconImage;
        NSString *imageURL = [tabbarDict valueForKey:@"image_url"];
        
        if(imageURL && [imageURL containsString:@"http"]){
            iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tabbarDict valueForKey:@"image_url"]]]];
            iconImage = [Tools imageWithImage:iconImage scaledToSize:CGSizeMake(30, 30)];
        }else{
            imageURL = nil;
        }
        
        UITabBarItem *item;
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"share_item"]){
            iconImage = [UIImage imageNamed:@"share_30x30"];
            shareItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:84];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"menu_item"]){
            iconImage = [UIImage imageNamed:@"menu_30x30"];
            menuItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:42];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"homepage_item"]){
            iconImage = [UIImage imageNamed:@"home_30x30"];
            homeItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:24];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:24]];
            continue;
        }
        item = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:10+i];
        [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:10+i]];
        [tabBarArray addObject:item];
    }
    //set menu and homepage items
    [tabBarArray insertObject:homeItem atIndex:0];
    [tabBarArray addObject:shareItem];
    [tabBarArray addObject:menuItem];
    
    [_tabbar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabbar items]]];
    
    //some shadow UI
    _tabbar.layer.shadowOffset = CGSizeMake(0, 0);
    _tabbar.layer.shadowRadius = 8;
    _tabbar.layer.shadowColor = [UIColor grayColor].CGColor;
    _tabbar.layer.shadowOpacity = 0.2;
    _tabbar.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    _tabbar.layer.borderWidth = 0;
    _tabbar.layer.borderColor = [[UIColor clearColor] CGColor];
    [[UITabBar appearance] setShadowImage:nil];
}


-(void)setActiveTabbarItem{
    int i = 0;
    NSArray *ar = [_tabbar items];
    for(i = 0 ; i< ar.count ; i++){
        UITabBarItem *it = ar[i];
        if(it.tag == _activeTab){
            _tabbar.selectedItem = it;
            break;
        }
    }
}


-(BOOL)isDeviceIPad{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    return (screenWidth > 444);
}

-(void)setConstraintZeroToView:(UIView *)viewToUpdate{
    [viewToUpdate addConstraint:[NSLayoutConstraint constraintWithItem:viewToUpdate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.]];
}


@end
