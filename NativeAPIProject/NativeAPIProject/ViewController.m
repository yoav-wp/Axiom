//
//  ViewController.m
//  scrollViewTest
//
//  Created by Design Webpals on 26/07/2016.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "CategoryVC.h"
#import "WebViewVC.h"
#import "NavigationManager.h"
#import "BrandReviewVC.h"
#import "HomePageTableViewCell.h"
#import "GlobalVars.h"
#import "HomePageIpadTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Tools.h"
#import "MappingFinder.h"
#import "UIImageViewBorder.h"

#define MAX_CAROUSEL_SIZE 10

@interface ViewController (){
    
    GlobalVars *globals;
    NSDictionary *brandsTable;
    
    NSString *bannerAffLink;
}


@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;
@property (weak, nonatomic) IBOutlet UIScrollView *carouselsv;
@property (weak, nonatomic) IBOutlet UIWebView *firstWYSIWYG;
@property (weak, nonatomic) IBOutlet UIWebView *secondWYSIWYG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWVHeight;
@property (weak, nonatomic) IBOutlet UITableView *brandsTableView;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandsTableViewHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *bannerBrand;
@property (weak, nonatomic) IBOutlet UILabel *bannerBonus;
@property (weak, nonatomic) IBOutlet UIButton *GetBannerButton;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *tableTitleLabel;
@end

static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";
static NSString * brandRevID = @"brandRevID";

@implementation ViewController{

    //TabBar items
    NSMutableDictionary *_tags2URLs;
    NavigationManager *_nav;
}
- (void)viewDidLoad {
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationRequestFromAppDel:) name:@"navigationRequestFromAppDel" object:Nil];
    
    // Allow interaction after file download
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    globals = [GlobalVars sharedInstance];
    
    self.pp = [[PalconParser alloc] init];
    _nav = [[NavigationManager alloc] init];
    
    
    self.activeTab = 24;
    [self.pp initWithFullURL:globals.websiteURL];
    
    globals.fontSize = @"16px";
    if([self isDeviceIPad]){
        globals.fontSize =@"19px";
    }
    
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    brandsTable = [_pp homepageGetTableWidget];
    [self initTableView];
}

//Google app indexing
-(void)navigationRequestFromAppDel:(NSNotification*)aNotif
{
    NSLog(@"vc got notif");
    NSString *urlFromNotification=[[aNotif userInfo] objectForKey:@"urlToLoad"];
    [_nav navigateWithItemID:-42 WithURL:urlFromNotification WithURLsDict:nil WithSourceVC:self WithInitializedDestPP:nil];
}

//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initFirstWysiwyg];
    [self initSecondWysiwyg];
    [self initAppTitle];
}

-(void)viewDidAppear:(BOOL)animated{
    //otherwise items are added on page reload (after failed share action)
    if([[_tabBar items] count] == 0)
        [self initTabBar];
    [self setActiveTabbarItem];
    [self initCarousel];
    [self initBanner];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableMenuUserInteraction" object:Nil userInfo:nil];
}

- (IBAction)closeBannerClick:(id)sender {
    [self removeBanner];
}
-(void)initAppTitle{
    _appTitleLabel.text = [_pp homepageGetAppTitle];
}

//init banner
-(void)initBanner{
    _GetBannerButton.layer.cornerRadius = 14;
    _GetBannerButton.layer.zPosition = 1;
    //new thread for banner
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1.0f];
        NSDictionary *bannerDict = [_pp homepageGetBannerDataDict];
        NSString *rightPart;
        NSString *leftPart;
        if([[bannerDict valueForKey:@"display_native_app_banner"] containsString:@"1"]){
            leftPart = [bannerDict valueForKey:@"brand_name"];
            rightPart = [bannerDict valueForKey:@"bonus_offer_sentence"];
            bannerAffLink = [bannerDict valueForKey:@"affiliate_link"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _bannerBonus.text = rightPart;
            _bannerBrand.text = leftPart;
            _bannerView.hidden = NO;
        });
    });
}
- (IBAction)bannerClicked:(id)sender {
    [_nav navigateToAffLink:bannerAffLink];
}

-(void)removeBanner{
    [_bannerView removeFromSuperview];
}
- (IBAction)bannerButtonClick:(id)sender {
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
//    rotationAnimation.duration = 3.;
//    rotationAnimation.cumulative = NO;
//    
//    [_GetBannerButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

//Handle widgets initializations
-(void)initCarousel{
    
    //get carousel from API
    NSArray *carousel = [_pp categoryGetCarousel];
    
    if(carousel.count == 0){
        _pageControl.hidden = YES;
    }else{
        //init pageControll number of dots (+1 if placeholder)
        [_pageControl setNumberOfPages:carousel.count + 1];
    }
    //init carousel UI
    CGRect frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width* 0.462);
    _carouselsv.frame = frame;
    CGFloat scrollViewWidth = self.carouselsv.frame.size.width;
    CGFloat scrollViewHeight = self.carouselsv.frame.size.height;
    //+1 because we use placeholder
    self.carouselsv.contentSize = CGSizeMake(self.carouselsv.frame.size.width * (carousel.count+1), self.carouselsv.frame.size.height);
    self.carouselsv.delegate = self;
    
    //Disable this for now, as we use a placeholder for the carousel
    /*
    if(carousel.count == 0 ){
        [self setConstraintZeroToView:_carouselsv];
        return;
    }
    */
    
    //first image is a placeholder
    UIImageView *firstImgV  = [[UIImageView alloc]initWithFrame:CGRectMake(0 * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
    [firstImgV setImage:[UIImage imageNamed:@"beting"]];
    
    //for now - placeholder - no navigation link
    firstImgV.tag = 300;
    [self.carouselsv addSubview:firstImgV];
    
    int i;
    for(i = 0; i < carousel.count; i++){
        UIImageView *imView = [[UIImageView alloc]initWithFrame:CGRectMake((i+1) * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
        NSURL *imgURL = [NSURL URLWithString:[carousel[i] valueForKey:@"brand_logo"]];
        [imView sd_setImageWithURL:imgURL];
        [self.carouselsv addSubview:imView];
        
        [[imView layer] setValue:[carousel[i] valueForKey:@"review_url"] forKey:@"urlToLoad"];
        
        //add touch event handler to the imageView
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPageOrSafariWithURL:)];
        [imView addGestureRecognizer:singleTap];
        [imView setUserInteractionEnabled:YES];
    }
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
    
    [_tabBar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabBar items]]];
    
    
    _tabBar.layer.borderWidth = 0;
    _tabBar.layer.borderColor = [UIColor clearColor].CGColor;
//    _tabBar.clipsToBounds = YES;
    
    //some shadow UI
    _tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    _tabBar.layer.shadowRadius = 8;
    _tabBar.layer.shadowColor = [UIColor grayColor].CGColor;
    _tabBar.layer.shadowOpacity = 0.6;
    _tabBar.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    _tabBar.layer.borderWidth = 1.0;
    _tabBar.layer.borderColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1].CGColor;

}


-(void)initFirstWysiwyg{
    [_firstWYSIWYG setBackgroundColor:[UIColor clearColor]];
    [_firstWYSIWYG setOpaque:NO];
    
    NSString *htmlString = [self.pp homepageGetFirstWysiwyg];
    if(htmlString.length < 8){
        [self setConstraintZeroToView:_firstWYSIWYG];
    }else{
        NSString *style = [Tools getDefaultWysiwygCSSFontSize:globals.fontSize];
        htmlString = [NSString stringWithFormat:@"%@<span>%@</span>",style,htmlString];
        [_firstWYSIWYG loadHTMLString:htmlString baseURL:nil];
        _firstWYSIWYG.scrollView.scrollEnabled = NO;
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(webView.tag ==1){
        CGRect frame = _firstWYSIWYG.frame;
        frame.size.height = 1;
        _firstWYSIWYG.frame = frame;
        CGSize fittingSize = [_firstWYSIWYG sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _firstWYSIWYG.frame = frame;
        _firstWVHeight.constant = frame.size.height;
    }
    else if(webView.tag == 2){
        CGRect frame = _secondWYSIWYG.frame;
        frame.size.height = 1;
        _secondWYSIWYG.frame = frame;
        CGSize fittingSize = [_secondWYSIWYG sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _secondWYSIWYG.frame = frame;
        _secondWVHeight.constant = frame.size.height;
    }
    
}


-(void)initSecondWysiwyg{
    //    NSLog(@"screen size %f, font size: %@", width, fontSize);
    NSString *htmlString = [self.pp homepageGetSecondWysiwyg];
    if(htmlString.length < 8){
        [self setConstraintZeroToView:_secondWYSIWYG];
    }else{
        NSString *style = [Tools getDefaultWysiwygCSSFontSize:globals.fontSize];
        htmlString = [NSString stringWithFormat:@"%@<span>%@</span>", style,htmlString];
        [_secondWYSIWYG loadHTMLString:htmlString baseURL:nil];
        _secondWYSIWYG.scrollView.scrollEnabled = NO;
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



-(void) initTableView{
    if([self isDeviceIPad]){
        [_tableTitleLabel setText:[brandsTable valueForKey:@"widget_header"]];
        NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
        NSUInteger nbRows = ar.count;
        
        if (nbRows < 1){
            [self setConstraintZeroToView:_midView];
        }
        _brandsTableViewHeightConst.constant = 120.0f * nbRows;
        [_brandsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomePageIpadTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomePageIpadTableViewCell class])];
        [_brandsTableView setScrollEnabled:NO];

    }else{
        [_tableTitleLabel setText:[brandsTable valueForKey:@"widget_header"]];
        NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
        NSUInteger nbRows = ar.count;
        
        if (nbRows < 1){
            [self setConstraintZeroToView:_midView];
        }
        _brandsTableViewHeightConst.constant = 90.0f * nbRows;
        [_brandsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomePageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomePageTableViewCell class])];
        [_brandsTableView setScrollEnabled:NO];

    }
}

//handle tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
    return ar.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self isDeviceIPad]){
        return 120.0f;
    }else{
        return 90.0f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self isDeviceIPad]){
        HomePageIpadTableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageIpadTableViewCell class]) forIndexPath:indexPath];
        
        NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
        //2 buttons
        [appCell.leftButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"review_link"] forState:UIControlStateNormal];
        [appCell.rightButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"button_text"] forState:UIControlStateNormal];
        [[appCell.leftButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"review_url"] forKey:@"urlToLoad"];
        [[appCell.rightButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"aff_url"] forKey:@"urlToLoad"];
        [appCell.leftButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
        [appCell.rightButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //add border
        [appCell.brandImageView sd_setImageWithURL:[ar[indexPath.row] valueForKey:@"brand_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            [appCell.brandImageView setImage:appCell.brandImageView.image withBorderWidth:4];
        }];
        
        //add border
        appCell.brandImageView.layer.borderColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1].CGColor;
        appCell.brandImageView.layer.borderWidth = 0.9f;
        
        
        //bonus text
        [appCell.bonusLabel setText:[NSString stringWithFormat:@"%@ %@",[ar[indexPath.row] valueForKey:@"trans_get"],[ar[indexPath.row] valueForKey:@"bonus_text"]]];
        
        //rating
        [appCell.ratingImageView setImage:[UIImage imageNamed:[[NSString stringWithFormat:@"rating%@",[ar[indexPath.row] valueForKey:@"star_rating"]] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]];
        
        appCell.ratingImageView.image = [appCell.ratingImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [appCell.ratingImageView setTintColor:[UIColor colorWithRed:146/255.0 green:142/255.0 blue:169/255.0 alpha:1]];
        
        return appCell;
    }else{
        HomePageTableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageTableViewCell class]) forIndexPath:indexPath];
        
        NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
        //2 buttons
        [appCell.leftButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"review_link"] forState:UIControlStateNormal];
        
        
        
        [appCell.rightButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"button_text"] forState:UIControlStateNormal];
        [[appCell.leftButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"review_url"] forKey:@"urlToLoad"];
        [[appCell.rightButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"aff_url"] forKey:@"urlToLoad"];
        [appCell.leftButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
        [appCell.rightButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
        
        appCell.leftButtonLabel.titleLabel.numberOfLines = 1;
        appCell.leftButtonLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
        appCell.leftButtonLabel.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        appCell.rightButtonLabel.titleLabel.numberOfLines = 1;
        appCell.rightButtonLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
        appCell.rightButtonLabel.titleLabel.lineBreakMode = NSLineBreakByClipping;
        
        //brand logo
        [appCell.brandImageView sd_setImageWithURL:[ar[indexPath.row] valueForKey:@"brand_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            [appCell.brandImageView setImage:appCell.brandImageView.image withBorderWidth:4];
        }];
        
        //add border
        appCell.brandImageView.layer.borderColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1].CGColor;
        appCell.brandImageView.layer.borderWidth = 0.9f;
        
        
        //bonus text
        appCell.bonusLabel.titleLabel.numberOfLines = 2;
//        [appCell.bonusLabel.titleLabel setText:[NSString stringWithFormat:@"%@ %@",[ar[indexPath.row] valueForKey:@"trans_get"],[ar[indexPath.row] valueForKey:@"bonus_text"]]];
        [appCell.bonusLabel setTitle:[NSString stringWithFormat:@"%@ %@",[ar[indexPath.row] valueForKey:@"trans_get"],[ar[indexPath.row] valueForKey:@"bonus_text"]] forState:UIControlStateNormal];
        
//        CGSize size = [appCell.bonusLabel sizeThatFits:CGSizeMake(appCell.bonusLabel.frame.size.width, CGFLOAT_MAX)];
//        int nbLines = MAX((int)(size.height / appCell.bonusLabel.font.lineHeight), 0);
        
        
        
        //rating
        [appCell.ratingImageView setImage:[UIImage imageNamed:[[NSString stringWithFormat:@"rating%@",[ar[indexPath.row] valueForKey:@"star_rating"]] stringByReplacingOccurrencesOfString:@"." withString:@"-"]]];
        
        appCell.ratingImageView.image = [appCell.ratingImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [appCell.ratingImageView setTintColor:[UIColor colorWithRed:146/255.0 green:142/255.0 blue:169/255.0 alpha:1]];
        
        return appCell;
    }
}

/**
 Checks if sender's link contains a page or affiliate links, and opens it

 @param sender Sender's object - imageView or Button
 */
-(void)openPageOrSafariWithURL:(id) sender{
    NSString *urlStr;
    //could be button or image
    if([sender isKindOfClass:[UIButton class]]){
        urlStr = [[sender layer] valueForKey:@"urlToLoad"];
    }else{
        urlStr = [[[sender view] layer] valueForKey:@"urlToLoad"];
    }
    if([urlStr containsString:[NSString stringWithFormat:@"%@links",globals.websiteURL]] || [urlStr containsString:[NSString stringWithFormat:@"%@links/",globals.websiteURL]]){
        //do mf
        [_nav navigateToAffLink:urlStr];
    }else{
        [_nav navigateWithItemID:-42 WithURL:urlStr WithURLsDict:nil WithSourceVC:self WithInitializedDestPP:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     
-(void)setActiveTabbarItem{
 int i = 0;
 NSArray *ar = [_tabBar items];
 for(i = 0 ; i< ar.count ; i++){
     UITabBarItem *it = ar[i];
     if(it.tag == _activeTab){
         _tabBar.selectedItem = it;
         break;
     }
 }
}



//Handle scrolling
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
//	CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
//	CGFloat currentPage = floor((scrollView.contentOffset.y - pageWidth/2)/pageWidth)+1;
	
    NSInteger page = scrollView.contentOffset.x / 375;
    _pageControl.currentPage = page;
    
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
