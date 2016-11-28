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
#import "MappingFinder.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;
@property (weak, nonatomic) IBOutlet UIScrollView *carouselsv;
@property (weak, nonatomic) IBOutlet UIWebView *firstWYSIWYG;
@property (weak, nonatomic) IBOutlet UIWebView *secondWYSIWYG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWVHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWVHeight;
@property (weak, nonatomic) IBOutlet UITableView *brandsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandsTableViewHeightConst;
@property (weak, nonatomic) IBOutlet UIButton *GetBannerButton;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
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
    self.pp = [[PalconParser alloc] init];
    _nav = [[NavigationManager alloc] init];
    self.activeTab = 24;
    [self.pp initWithFullURL:@"http://www.onlinecasinos.expert/homepage.js"];
//    self.tabBar.selectedItem= self.tabBar.items[0];
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
}

//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initFirstWysiwyg];
    [self initSecondWysiwyg];
    [self initCarousel];
    [self initTableView];
    [self initTabBar];
    [self initBanner];
    [self setActiveTabbarItem];
    
    int index = 3;
    int num = 123456;
    int leftPart = num / (pow(10, index));
    int rightPart = ((int)num % (int)(pow(10,(int)index)));
    NSLog(@"leftpart : %d rightpart : %d", (int)leftPart, rightPart);
}
- (IBAction)closeBannerClick:(id)sender {
    [self removeBanner];
}

//init banner, show and remove it after 5 sec
-(void)initBanner{
    _GetBannerButton.layer.cornerRadius = 14;
    _GetBannerButton.layer.zPosition = 1;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeBanner) userInfo:nil repeats:NO];
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

//#############################Start initializations##############################################
//Handle widgets initializations
-(void)initCarousel{
    
    //init carousel UI
    _carouselsv.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width* 0.462);
    CGFloat scrollViewWidth = self.carouselsv.frame.size.width;
    CGFloat scrollViewHeight = self.carouselsv.frame.size.height;
    //finish UI
    self.carouselsv.contentSize = CGSizeMake
    (self.carouselsv.frame.size.width * 4, self.carouselsv.frame.size.height);
    self.carouselsv.delegate = self;
    
    //get carousel from API
    NSMutableArray *carousel = [self.pp categoryGetCarousel];
    
    NSLog(@"carousel count %ld",carousel.count);
    
    if(carousel.count == 0 ){
        [self setConstraintZeroToView:_carouselsv];
        return;
    }
    
    //Set carousel data in the imageViews
    NSMutableArray *carouselImageViewsArray = [NSMutableArray array];
    int i = 0;
    for(i = 0; i< carousel.count ; i++){
        NSDictionary * carouselDict = carousel[i];
        //NSLog(@"yoav Ya: %@",[carouselDict valueForKey:@"label"] );
        
        carouselImageViewsArray[i] = [[UIImageView alloc]initWithFrame:CGRectMake(i * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
        NSURL *imgURL = [NSURL URLWithString:[carouselDict valueForKey:@"image_url"]];
        [carouselImageViewsArray[i] sd_setImageWithURL:imgURL];
        [self.carouselsv addSubview:carouselImageViewsArray[i]];
    }
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
    
    [_tabBar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabBar items]]];
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
    
//    NSLog(@"screen size %f, font size: %@", width, fontSize);
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,[self.pp homepageGetFirstWysiwyg]];
    [_firstWYSIWYG loadHTMLString:htmlString baseURL:nil];
    _firstWYSIWYG.scrollView.scrollEnabled = NO;
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
        NSLog(@"aaa%f", frame.size.height);
    }
    else if(webView.tag == 2){
        CGRect frame = _secondWYSIWYG.frame;
        frame.size.height = 1;
        _secondWYSIWYG.frame = frame;
        CGSize fittingSize = [_secondWYSIWYG sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        _secondWYSIWYG.frame = frame;
        _secondWVHeight.constant = frame.size.height;
        NSLog(@"bbb%f", frame.size.height);
    }
    
}


-(void)initSecondWysiwyg{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
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
    
    //    NSLog(@"screen size %f, font size: %@", width, fontSize);
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</span>",fontSize,[self.pp homepageGetSecondWysiwyg]];
    [_secondWYSIWYG loadHTMLString:htmlString baseURL:nil];
    _secondWYSIWYG.scrollView.scrollEnabled = NO;
}


/**
 If I wanna handle click on link on a TextView, impl. this

 @param textView
 @param URL
 @param characterRange
 @return
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSLog(@"bla bla %@", [URL absoluteString]);
    return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //open page from wysiwyg
    NSString *urlString = [[request URL] absoluteString];
    NavigationManager *nav = [[NavigationManager alloc] init];
    NSLog(@"url : %@",urlString);
    if([urlString containsString:[[GlobalVars sharedInstance] websiteURL]]){
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





-(void) initTableView{
    
    int nbRows = 3;
    _brandsTableViewHeightConst.constant = 90.0f * nbRows;
    [_brandsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomePageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomePageTableViewCell class])];
    [_brandsTableView setScrollEnabled:NO];
    
    
}

//handle tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageTableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomePageTableViewCell class]) forIndexPath:indexPath];
    [appCell.leftButtonLabel setTitle:[NSString stringWithFormat:@"Review %ld", indexPath.row] forState:UIControlStateNormal];
    return appCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//################################End of initializations###########################################

//################################Start of Events Handling###########################################


//Handle tabBar clicks
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

//Sharing
-(void)handleSharingEvent{
    // create a message
    NSString *theMessage = [self.pp fullURL];
    NSArray *items = @[@"hello", [UIImage imageNamed:@"betwaylogo"]];
    
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
	
	NSLog(@"scroll y: %f", scrollView.contentOffset.y);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	if(scrollView.tag == 1){
//		NSLog(@"moving main");
//	}
//	if(scrollView.tag == 2){
//		NSLog(@"moving carousel");
//	}
}

//################################Start of Events Handling###########################################

-(void)setConstraintZeroToView:(UIView *)viewToUpdate{
    [viewToUpdate addConstraint:[NSLayoutConstraint constraintWithItem:viewToUpdate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.]];
}


@end
