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
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainSV;
@property (weak, nonatomic) IBOutlet UIScrollView *carouselsv;
@property (weak, nonatomic) IBOutlet UIStackView *firstStack;
@property (weak, nonatomic) IBOutlet UITextView *firstWysiwyg;
@property (weak, nonatomic) IBOutlet UITextView *secondWysiwyg;
@property (weak, nonatomic) IBOutlet UIButton *GetBannerButton;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";

@implementation ViewController{

    //TabBar items
    NSMutableDictionary *_tags2URLs;
}
- (void)viewDidLoad {
	[super viewDidLoad];
    self.pp = [[PalconParser alloc] init];
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
}
- (IBAction)closeBannerClick:(id)sender {
    [self removeBanner];
}

-(void)initBanner{
    _GetBannerButton.layer.cornerRadius = 14;
    _GetBannerButton.layer.zPosition = 1;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeBanner) userInfo:nil repeats:NO];
}

-(void)removeBanner{
    [_bannerView removeFromSuperview];
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
    
    //set middle items
    //Homepage and menu position in the json array doesnt matter, for the others it does.
    for(i = 0; i < self.tabbarElements.count; i++){
        NSDictionary *tabbarDict = self.tabbarElements[i];
        UITabBarItem *item;
        if([[tabbarDict valueForKey:@"id"] isEqualToString:@"menu_item"]){
            menuItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:42];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:42]];
            continue;
        }
        if([[tabbarDict valueForKey:@"id"] isEqualToString:@"homepage_item"]){
            homeItem = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:24];
            [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:24]];
            continue;
        }
        
        item = [[UITabBarItem alloc] initWithTitle:[tabbarDict valueForKey:@"button_text"] image:nil tag:10+i];
        [_tags2URLs setObject:[tabbarDict valueForKey:@"link"] forKey:[NSNumber numberWithInteger:10+i]];
        [tabBarArray addObject:item];
    }
    //set menu and homepage items
    [tabBarArray insertObject:homeItem atIndex:0];
    [tabBarArray addObject:menuItem];
    
    
    [_tabBar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabBar items]]];
}

-(void)initFirstWysiwyg{
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
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,[self.pp homepageGetFirstWysiwyg]];

    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.firstWysiwyg.attributedText = attributedString;
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
    
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:arial;color:grey;font-size:%@\">%@</spann>",fontSize,[self.pp homepageGetSecondWysiwyg]];
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.secondWysiwyg.attributedText = attributedString;
//    CGRect frame = _secondWysiwyg.frame;
//    frame.size.height = _secondWysiwyg.contentSize.height;
//    _secondWysiwyg.frame = frame;
}


-(void) initTableView{
    
}

//handle tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *appCell = [tableView dequeueReusableCellWithIdentifier:@"homePageCell"];
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
    [self handleTabBarSelectionWithItemID:item.tag];
}


//we have: tag ID, pp, tabbarElements (array with button txt, link, img url)
-(void) handleTabBarSelectionWithItemID: (NSInteger) tag{
    
    NSLog(@"clicked on %ld",(long)tag);
    //On homepage, homepage click does nothing
    if (tag == 42){
        [self.revealViewController rightRevealToggle:self];
    }
    //On menu click, action is static - always open menu
    else if (tag == 24){
        //homepage, do nothing
    }
    else{
        NSString *targetURL = [_tags2URLs objectForKey:[NSNumber numberWithInteger:tag]];
        NSLog(@"target url : %@",targetURL);
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:targetURL];
        
        
        if([[destPP getPageType]isEqualToString:@"webview_page"]){
            NSLog(@"entered WV if");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"category_page"]){
            NSLog(@"entered WV if");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
            [segue perform];
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


@end
