//
//  WebViewVC.m
//  scrollViewTest
//
//  Created by Nir Gaiger on 8/10/16.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "WebViewVC.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "CategoryVC.h"

@interface WebViewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end


static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";

@implementation WebViewVC{
    NSMutableDictionary *_tags2URLs;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewdidload");
    
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
}

//call all the widgets initializations
//better view WILL appear, did appear for debug
-(void)viewDidAppear:(BOOL)animated{
    // Do any additional setup after loading the view, typically from a nib.
    [self initWebView];
    [self initTabBar];
    [self setSelectedTabbarItem];
}

-(void)setSelectedTabbarItem{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initWebView{
    NSURL *url = [NSURL URLWithString:[self.pp getBaseURL]];
    NSURLRequest *rq =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:rq];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
        [segue perform];
    }
    else{
        if(tag == _activeTab){
            return;
        }
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



#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}


@end
