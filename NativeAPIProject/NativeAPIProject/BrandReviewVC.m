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
#import <SDWebImage/UIImageView+WebCache.h>
#import "NavigationManager.h"

@interface BrandReviewVC(){
    GlobalVars *globals;
}


@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIView *accordionView;
@property (weak, nonatomic) IBOutlet UIView *firstTabView;
@property (weak, nonatomic) IBOutlet UIView *secondTabView;
@property (weak, nonatomic) IBOutlet UIView *thirdTabView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accordionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tosWysiwygHeightConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *secondTabWebView;
@property (weak, nonatomic) IBOutlet UIWebView *firstWysiwyg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWysiwygHeightConst;
@property (weak, nonatomic) IBOutlet UIStackView *carouselStackView;
@property (weak, nonatomic) IBOutlet UIImageView *firstScreenShotPlaceholder;

//bottom view of the third tab's view
@property (weak, nonatomic) IBOutlet UIView *thirdsBottomView;
@property (weak, nonatomic) IBOutlet UIWebView *tosWV;

@end


CGFloat maxAccordionHeight = 0;

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
    globals = [GlobalVars sharedInstance];
    //Just add the imageviews to an array,to iterate later
    paymentMethodsImageViewsArray = [NSArray arrayWithObjects:_paymentMethodImgV1, _paymentMethodImgV2, _paymentMethodImgV3, _paymentMethodImgV4, _paymentMethodImgV5, _paymentMethodImgV6, _paymentMethodImgV7, _paymentMethodImgV8, _paymentMethodImgV9, nil];
    softwareProvidersImageViewsArray = [NSArray arrayWithObjects:_swProviderImgV1, _swProviderImgV2, _swProviderImgV3, _swProviderImgV4, nil];
    
    //    self.tabBar.selectedItem= self.tabBar.items[0];
    //for the menu
    _nav = [[NavigationManager alloc] init];
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    [self initSegmentViews];
    [self initAccordionView];
    [self initWV];
    [self initSecondTabWebView];
    [self initSomeUI];
    [self initFirstWysiwyg];
    [self initPaymentMethods];
    [self initSoftwareProviders];
    [self initScreenshots];
    [self initTOSWV];
}

// Some general page UI
-(void)initSomeUI{
    //borders
    _thirdsBottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _thirdsBottomView.layer.borderWidth = 0.5f;
}


-(void)viewDidAppear:(BOOL)animated{
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
        if(i == 4)
            break;
        UIImageView *currentIV = softwareProvidersImageViewsArray[i];
        CGRect frame = CGRectMake(currentIV.frame.origin.x, currentIV.frame.origin.y, 34, 20);
        currentIV.frame = frame;
        [currentIV sd_setImageWithURL:providers[i]];
    }
}

-(void)initTOSWV{
    _tosWV.scrollView.scrollEnabled = NO;
    NSString *urlString = [self.pp brandReviewGetTOSWysiwyg];
    [_tosWV loadHTMLString:urlString baseURL:nil];
}

-(void)initFirstWysiwyg{
    NSString *urlString = [self.pp brandReviewGetWysiwyg];
    [_firstWysiwyg loadHTMLString:urlString baseURL:nil];
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
        NSLog(@"aaa%f", frame.size.height);
    }else if (webView.tag == 15){
        CGRect frame = _tosWV.frame;
        frame.size.height = 1;
        _tosWV.frame = frame;
        CGSize fittingSize = [_tosWV sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _tosWV.frame = frame;
        _tosWysiwygHeightConstraint.constant = frame.size.height;
        NSLog(@"yyyyy%f", frame.size.height);
    }
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
        NSLog(@"aaa %f",webView.frame.size.height);
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
    
    //widths : 6sPlus - 414, 6s - 375, ipad air and air 2, retina - 768,ipad pro 12.9inch - 1024, 5s and 7 SE - 320
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    accordionWVArray = [NSMutableArray array];
    _accordionHeightConstraint.constant = 760;
    
    CGFloat accordionWidth = self.view.frame.size.width;
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, accordionWidth, [[UIScreen mainScreen] bounds].size.height)];
    [self.accordionView addSubview:accordion];
    self.accordionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
    
    
    NSLog(@"screen width : %f",screenWidth);
    int i = 1;
    for(i = 1 ; i< 4 ; i++){
//        float rating = 3.5;
//        rating *=10;
//        NSString *filename= [NSString stringWithFormat:@"rating%.0fup",rating];
//        NSLog(@" filename %@",filename);
        // Only height is taken into account, so other parameters are just dummy
        UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [header1 setTitle:@" Welcome Bonus" forState:UIControlStateNormal];
        
        
        UIImageView *ratingImgView;
        UIImageView *buttonImgView;
        CGFloat ratingImageX = 200;
        CGFloat ratingImageWidth = 80;
        CGFloat buttonImgX = 300;
        CGFloat buttonImgWidth = 20;
        
        //iphone 7 edge
        if(screenWidth <= 375){
            buttonImgX = screenWidth - (buttonImgWidth + 4);
            ratingImageX = screenWidth - (ratingImageWidth + screenWidth - buttonImgX);
            //most iphones
        }else if(screenWidth <= 375){
            buttonImgX = screenWidth - (buttonImgWidth + 4);
            ratingImageX = screenWidth - (ratingImageWidth + screenWidth + 20 - buttonImgX);
            //Plus iphones
        }else if(screenWidth <= 414){
            buttonImgX = screenWidth - (buttonImgWidth + 10);
            ratingImageX = screenWidth - (ratingImageWidth + screenWidth - buttonImgX);
            //ipads
        }else{
            buttonImgX = screenWidth - (buttonImgWidth + 10);
            ratingImageX = screenWidth - (ratingImageWidth + screenWidth + 200 - (buttonImgX));
        }
        
        
        ratingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ratingImageWidth, 5, ratingImageX, 20)];
        [header1 addSubview:ratingImgView];
        [ratingImgView setImage:[UIImage imageNamed:@"rating25"]];
        [ratingImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        buttonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonImgX, 5, buttonImgWidth, 20)];
        [header1 addSubview:buttonImgView];
        [buttonImgView setImage:[UIImage imageNamed:@"accordion_arrow"]];
        
        [buttonImgView setContentMode:UIViewContentModeScaleAspectFit];
        buttonImgView.tag = 10;
        
        //if first element, we rotate the image, as tab is open.
        if(i == 1){
            UIImage *rotated = [self upsideDownBunny:M_PI withImage:buttonImgView.image];
            buttonImgView.image = rotated;
        }
        //if last element, we rotate it 90
        if(i == 3){
            UIImage *rotated = [self upsideDownBunny:M_PI/2 withImage:buttonImgView.image];
            buttonImgView.image = rotated;
        }
        
        [header1 addTarget:self action:@selector(changeAccordionArrowOrientation:) forControlEvents:UIControlEventTouchUpInside];
        header1.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        header1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        header1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
        [header1 setTitleColor:[UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:1.000] forState:UIControlStateNormal];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 242)];
        view1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
        
        [accordion addHeader:header1 withView:view1];
        view1.tag = 3*i;
        
        
        //if not last element
        if(i != 4-1){
            
            UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, accordionWidth, 1)];
            wv.delegate = self;
            wv.tag = i;
            //disable scrolling in webview
            [[wv scrollView] setScrollEnabled:NO];
            [wv setUserInteractionEnabled:NO];
            //disable background color in webview
            [wv setBackgroundColor:[UIColor clearColor]];
            [wv setOpaque:NO];

            [view1 addSubview:wv];
            [wv loadHTMLString:@"<div>second WYSIWYG <b>this is bold</b><p>Lets <a href=\"http://www.onlinecasinos.expert/page4.js\">start</a> a new paragraph and close it</p> this is the second <i>WYSIWYG</i> for thisthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i> for this Homepage Homepage HomepageHomepage Homepagthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i> for this Homepage Homepage HomepageHomepage Homepagthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i>page</div>" baseURL:nil];
            [accordionWVArray addObject:wv];
            
            //update total height for best scrolling
            maxAccordionHeight += 300;
        }else{
            //if last element
            header1.backgroundColor = [UIColor colorWithRed:76/255.0 green:75/255.0 blue:89/255.0 alpha:1];
            [header1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonImgView setTintColor:[UIColor redColor]];
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



-(void)changeAccordionArrowOrientation:(id) sender{
    UIButton *button = (UIButton *) sender;
    for (UIView *i in button.subviews){
        if([i isKindOfClass:[UIImageView class]]){
            UIImageView *imgV = (UIImageView *)i;
            if(imgV.tag == 10){
                UIImage *rotated = [self upsideDownBunny:M_PI withImage:imgV.image];
                imgV.image = rotated;
                
                //attempts to display an animation - not working
                
                
/*
                [UIView animateWithDuration:0.5f animations:^{
                    [imgV setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];


                
                CABasicAnimation* rotationAnimation;
                rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                rotationAnimation.fromValue = 0;
                rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1* 1 ];
                rotationAnimation.duration = 0.5f;
                rotationAnimation.cumulative = NO;
                rotationAnimation.repeatCount = 0;
                rotationAnimation.removedOnCompletion = YES;
                
                [imgV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                
                
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25]; // Set how long your animation goes for
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                
                imgV.transform = CGAffineTransformMakeRotation(M_PI); // if angle is in radians
                
                [UIView commitAnimations];
 */
                
            }
        }
    }
}


-(void)initWV{
    
}

-(void)initSecondTabWebView{
    NSString *s = [self.pp brandReviewGetSecondTabWysiwyg];
    [_secondTabWebView loadHTMLString:s baseURL:nil];
}

//
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGRect frame = _webview.frame;
//    frame.size.height = 1;
//    _webview.frame = frame;
//    CGSize fittingSize = [_webview sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    _webview.frame = frame;
//    _webviewHeight.constant = frame.size.height;
//}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //open page from wysiwyg
    NSString *urlString = [[request URL] absoluteString];
    NavigationManager *nav = [[NavigationManager alloc] init];
    NSLog(@"url : %@",urlString);
    NSMutableString *website = [NSMutableString stringWithString:globals.websiteURL];
    //remove the http if exists
    [website replaceOccurrencesOfString:@"http://" withString:@"" options:NSAnchoredSearch range:NSMakeRange(0, website.length)];
    [website replaceOccurrencesOfString:@"https://" withString:@"" options:NSAnchoredSearch range:NSMakeRange(0, website.length)];
    if([urlString containsString:website]){
#warning hmm need to pass tags2URLs??
        [nav navigateWithItemID:-42 WithURL:urlString WithURLsDict:_tags2URLs WithSourceVC:self];
        return NO;
    }
    
    
    //MappingFinderPart
    MappingFinder *st = [MappingFinder getMFObject];
    NSURL *url = [request URL];
    url= [st makeURL:url trigger:@"go"];
    
    if (([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"])) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

- (IBAction)segmentValueChanged:(id)sender {
    
    CGRect frame = _thirdTabView.frame;
    CGSize fittingSize = [_thirdTabView sizeThatFits:_thirdTabView.frame.size];
    frame.size = fittingSize;
    NSLog(@"changed %ld, size : %f",(long)_segment.selectedSegmentIndex, frame.size.height);
    switch (_segment.selectedSegmentIndex) {
        case 0:
            _secondTabView.hidden=YES;
            _thirdTabView.hidden=YES;
            _firstTabView.hidden=NO;
            break;
        case 1:
            _firstTabView.hidden=YES;
            _thirdTabView.hidden=YES;
            _secondTabView.hidden=NO;
            break;
            
        case 2:
            _firstTabView.hidden=YES;
            _secondTabView.hidden=YES;
            _thirdTabView.hidden=NO;
            break;
            
        default:
            //default show 0
            break;
    }
}


//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initTabBar];
    [self setActiveTabbarItem];
}


//Sharing
-(void)handleSharingEvent{
    // create a message
    NSString *theMessage = [self.pp fullURL];
    NSArray *items = @[@"My Share Item - Yoav", [UIImage imageNamed:@"betwaylogo"]];
    
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

//menu tag: 42, homepage tag: 24
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
        UITabBarItem *item;
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"share_item"]){
            UIImage * iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tabbarDict valueForKey:@"image_url"]]]];
            shareItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:84];
            //            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:84]];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"menu_item"]){
            UIImage * iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tabbarDict valueForKey:@"image_url"]]]];
            menuItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:42];
            //            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:42]];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isKindOfClass:[NSString class]] && [[tabbarDict valueForKey:@"id"] isEqualToString:@"homepage_item"]){
            UIImage * iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tabbarDict valueForKey:@"image_url"]]]];
            homeItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:24];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:24]];
            continue;
        }
        UIImage * iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tabbarDict valueForKey:@"image_url"]]]];
        item = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:iconImage tag:10+i];
        [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:10+i]];
        [tabBarArray addObject:item];
    }
    //set menu and homepage items
    [tabBarArray insertObject:homeItem atIndex:0];
    [tabBarArray addObject:shareItem];
    [tabBarArray addObject:menuItem];
    
    [_tabbar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabbar items]]];
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

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"tag : %ld",item.tag);
    if (item.tag == 42){
        [self.revealViewController rightRevealToggle:self];
    }else if(item.tag == 84){
        [self handleSharingEvent];
    }
    else if(item.tag == _activeTab){
        return;
    }else{
        [_nav navigateWithItemID:item.tag WithURL:nil WithURLsDict:_tags2URLs WithSourceVC:self];
    }
}


-(void)setConstraintZeroToView:(UIView *)viewToUpdate{
    [viewToUpdate addConstraint:[NSLayoutConstraint constraintWithItem:viewToUpdate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.]];
}


@end
