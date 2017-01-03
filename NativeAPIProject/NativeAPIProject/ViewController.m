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
#import <SDWebImage/UIImageView+WebCache.h>
#import "Tools.h"
#import "MappingFinder.h"

#define MAX_CAROUSEL_SIZE 10

@interface ViewController (){
    
    GlobalVars *globals;
    NSDictionary *brandsTable;
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
    
    globals = [GlobalVars sharedInstance];
    
    self.pp = [[PalconParser alloc] init];
    _nav = [[NavigationManager alloc] init];
    
    self.activeTab = 24;
    [self.pp initWithFullURL:globals.websiteURL];
    
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    brandsTable = [_pp homepageGetTableWidget];
    [self initTableView];
}

//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initFirstWysiwyg];
    [self initSecondWysiwyg];
    [self initCarousel];
    [self initAppTitle];
    [self initBanner];
}

-(void)viewDidAppear:(BOOL)animated{
    //otherwise items are added on page reload (after failed share action)
    if([[_tabBar items] count] == 0)
        [self initTabBar];
    [self setActiveTabbarItem];
}

//Google app indexing
-(void)navigationRequestFromAppDel:(NSNotification*)aNotif
{
    NSString *aStrUrl=[[aNotif userInfo] objectForKey:@"urlToLoad"];
    [_nav navigateWithItemID:-42 WithURL:aStrUrl WithURLsDict:nil WithSourceVC:self];
}

- (IBAction)closeBannerClick:(id)sender {
    [self removeBanner];
}
-(void)initAppTitle{
    _appTitleLabel.text = [_pp homepageGetAppTitle];
}

//init banner, show and remove it after 5 sec
-(void)initBanner{
    _GetBannerButton.layer.cornerRadius = 14;
    _GetBannerButton.layer.zPosition = 1;
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(removeBanner) userInfo:nil repeats:NO];
}

-(void)removeBanner{
    [_bannerView removeFromSuperview];
}
- (IBAction)bannerButtonClick:(id)sender {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 3.;
    rotationAnimation.cumulative = NO;
    
    [_GetBannerButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    
    //some shadow UI
    _tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    _tabBar.layer.shadowRadius = 8;
    _tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _tabBar.layer.shadowOpacity = 0.2;
    _tabBar.layer.backgroundColor = [UIColor whiteColor].CGColor;
}


-(void)initFirstWysiwyg{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [_firstWYSIWYG setBackgroundColor:[UIColor clearColor]];
    [_firstWYSIWYG setOpaque:NO];

    CGFloat width = screenRect.size.width;
    NSString *fontSize = @"";
//    NSLog(@"screen size %f", width);
    if(width <= 400){
        fontSize = @"1em";
    }else if(width <= 500){
        fontSize = @"1.5em";
    }else{
        fontSize = @"2em";
    }
    
    NSString *htmlString = [self.pp homepageGetFirstWysiwyg];
    NSLog(@"ooooooo %@",htmlString);
    if(htmlString.length < 8){
        [self setConstraintZeroToView:_firstWYSIWYG];
    }else{
        htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,htmlString];
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat width = screenRect.size.width;
    NSString *fontSize = @"";
    if(width <= 400){
        fontSize = @"1em";
    }else if(width <= 500){
        fontSize = @"1.5em";
    }else{
        fontSize = @"2em";
    }
    
    //    NSLog(@"screen size %f, font size: %@", width, fontSize);
    NSString *htmlString = [self.pp homepageGetSecondWysiwyg];
    if(htmlString.length < 8){
        [self setConstraintZeroToView:_secondWYSIWYG];
    }else{
        htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,htmlString];
        [_secondWYSIWYG loadHTMLString:htmlString baseURL:nil];
        _secondWYSIWYG.scrollView.scrollEnabled = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //open page from wysiwyg
    NSString *urlString = [[request URL] absoluteString];
    NavigationManager *nav = [[NavigationManager alloc] init];
    if([urlString containsString:[[GlobalVars sharedInstance] websiteURL]]){
        [nav navigateWithItemID:-42 WithURL:urlString WithURLsDict:_tags2URLs WithSourceVC:self];
        return NO;
    }
    
     NSURL *url = [request URL];
    
#warning TODO - define mapping finder system - if url contains mappingfinder.com?
     if (([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"])) {
         
         MappingFinder *st = [MappingFinder getMFObject];
         url= [st makeURL:url trigger:@"go"];
         
         [[UIApplication sharedApplication] openURL:url];
         return NO;
     }
    return YES;
}

-(void) initTableView{
    
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

//handle tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
    return ar.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageTableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageTableViewCell class]) forIndexPath:indexPath];
    
    NSArray *ar = [brandsTable valueForKey:@"widgets_arr"];
    //2 buttons
    [appCell.leftButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"review_link"] forState:UIControlStateNormal];
    [appCell.rightButtonLabel setTitle:[ar[indexPath.row] valueForKey:@"button_text"] forState:UIControlStateNormal];
    [[appCell.leftButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"review_url"] forKey:@"urlToLoad"];
    [[appCell.rightButtonLabel layer] setValue:[ar[indexPath.row] valueForKey:@"aff_url"] forKey:@"urlToLoad"];
    [appCell.leftButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
    [appCell.rightButtonLabel addTarget:self action:@selector(openPageOrSafariWithURL:) forControlEvents:UIControlEventTouchUpInside];
    
    //brand logo
    [appCell.brandImageView sd_setImageWithURL:[ar[indexPath.row] valueForKey:@"brand_logo"]];
    
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
}
-(void)openPageOrSafariWithURL:(id) sender{
    
    NSString *urlStr;
#warning could be dangerous - watch it
    if([sender isKindOfClass:[UIButton class]]){
        urlStr = [[sender layer] valueForKey:@"urlToLoad"];
    }else{
        urlStr = [[[sender view] layer] valueForKey:@"urlToLoad"];
    }
    
//    urlStr = @"http://onlinecasinos.expert/go/leo-vegas";
    if([urlStr containsString:@"onlinecasinos.expert"]){
        //do mf
        MappingFinder *st = [MappingFinder getMFObject];
        NSURL *url= [st makeURL:[NSURL URLWithString:urlStr] trigger:@"go"];
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else{
        [_nav navigateWithItemID:-42 WithURL:urlStr WithURLsDict:nil WithSourceVC:self];
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
        [_nav navigateWithItemID:item.tag WithURL:nil WithURLsDict:_tags2URLs WithSourceVC:self];
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


-(void)setConstraintZeroToView:(UIView *)viewToUpdate{
    [viewToUpdate addConstraint:[NSLayoutConstraint constraintWithItem:viewToUpdate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.]];
}


@end
