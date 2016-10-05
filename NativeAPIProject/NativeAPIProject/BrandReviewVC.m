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
#import "NavigationManager.h"

@interface BrandReviewVC()

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIView *accordionView;
@property (weak, nonatomic) IBOutlet UIView *firstTabView;
@property (weak, nonatomic) IBOutlet UIView *secondTabView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accordionHeightConstraint;
@property (weak, nonatomic) IBOutlet UIWebView *secondTabWebView;

@end


CGFloat maxAccordionHeight = 0;

@implementation BrandReviewVC{

    //TabBar items
    NSMutableDictionary *_tags2URLs;
    NSMutableArray * accordionWVArray;
    AccordionView *accordion;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.tabBar.selectedItem= self.tabBar.items[0];
    //for the menu
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    [self initWV];
    [self initSecondTabWebView];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initAccordionView];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
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



-(void)initAccordionView{

    accordionWVArray = [NSMutableArray array];
    _accordionHeightConstraint.constant = 760;
    
    CGFloat width = self.view.frame.size.width;
    accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, width, [[UIScreen mainScreen] bounds].size.height)];
    [self.accordionView addSubview:accordion];
    self.accordionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
    
    int i = 1;
    for(i = 1 ; i< 4 ; i++){
        // Only height is taken into account, so other parameters are just dummy
        UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [header1 setTitle:@"First row" forState:UIControlStateNormal];
        header1.backgroundColor = [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1.000];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 242)];
        view1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.000];
        
        [accordion addHeader:header1 withView:view1];
        view1.tag = 3*i;
        
        UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        wv.delegate = self;
        wv.tag = i;
        [[wv scrollView] setScrollEnabled:NO];

        [view1 addSubview:wv];
        [wv loadHTMLString:@"<div>second WYSIWYG <b>this is bold</b><p>Lets <a href=\"http://www.onlinecasinos.expert/page2.js\">start</a> a new paragraph and close it</p> this is the second <i>WYSIWYG</i> for thisthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i> for this Homepage Homepage HomepageHomepage Homepagthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i> for this Homepage Homepage HomepageHomepage Homepagthe second <i>WYSIWYG</i> for this Homepage Homepage Homepage Homepage<i>WYSIWYG</i>page</div>" baseURL:nil];
        
        [accordionWVArray addObject:wv];
        
        //update total height for best scrolling
        maxAccordionHeight += 300;
        
    }

    [accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [accordion setAllowsMultipleSelection:YES];
    
    // Set this to NO if you want to have at least one open section at all times
    [accordion setAllowsEmptySelection:YES];
}




-(void)initWV{
    NSString *s = [self.pp brandReviewGetWysiwyg];
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
    NSString *url = [[request URL] absoluteString];
    NavigationManager *nav = [[NavigationManager alloc] init];
    NSLog(@"url : %@",url);
    if([url containsString:@"onlinecasinos.expert"]){
        [nav handleTabBarSelectionWithItemID:-42 WithURL:url WithURLsDict:_tags2URLs WithSourceVC:self];
        return NO;
    }
    return YES;
}

- (IBAction)segmentValueChanged:(id)sender {
    NSLog(@"changed %ld",(long)_segment.selectedSegmentIndex);
    switch (_segment.selectedSegmentIndex) {
        case 0:
            _firstTabView.hidden=NO;
            _secondTabWebView.hidden=YES;
            break;
        case 1:
            _firstTabView.hidden=YES;
            _secondTabWebView.hidden=NO;
            break;
            
        case 2:
            _firstTabView.hidden=NO;
            _secondTabWebView.hidden=YES;
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

//Handle tabBar clicks
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //On homepage, homepage click does nothing
    if (item.tag == 42){
        [self.revealViewController rightRevealToggle:self];
    }
    else if(item.tag == _activeTab){
        return;
    }else{
        NavigationManager *nav = [[NavigationManager alloc] init];
        [nav handleTabBarSelectionWithItemID:item.tag WithURL:nil WithURLsDict:_tags2URLs WithSourceVC:self];
    }
}




//menu tag: 42, homepage tag: 24
-(void)initTabBar{
    //contains list of : a tag and a url for it
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
    
    
    [_tabbar setItems:[tabBarArray arrayByAddingObjectsFromArray:[_tabbar items]]];
}




@end
