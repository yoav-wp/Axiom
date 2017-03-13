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
#import "NavigationManager.h"
#import "GlobalVars.h"
#import "Tools.h"
#import "CategoryVC.h"
#import "DGActivityIndicatorView.h"

@interface WebViewVC (){
    GlobalVars *globals;
    PalconParser *destPP;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end


static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";

@implementation WebViewVC{
    NSMutableDictionary *_tags2URLs;
    NavigationManager *_nav;
    DGActivityIndicatorView *activityIndicatorView;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationRequestFromAppDel:) name:@"navigationRequestFromAppDel" object:Nil];
    
    // Allow interaction after file download
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    _nav = [[NavigationManager alloc]init];
    globals = [GlobalVars sharedInstance];
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
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
    [self initTabBar];
    [self initWebView];
    [self setSelectedTabbarItem];
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableMenuUserInteraction" object:Nil userInfo:nil];
}



#warning feature - downloading pp twice
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //open page from wysiwyg
    NSString *urlString = [[request URL] absoluteString];
    
    if(![urlString containsString:globals.websiteURL]){
        return YES;
    }
    
    //if url contains "online-casinoes-canada.ca" && url contains "links", then it's an aff link.
    if (([urlString containsString:[[GlobalVars sharedInstance] websiteURL]] && [urlString containsString:globals.redirectionTrigger])) {
        [_nav navigateToAffLink:urlString];
        return NO;
    }
    
    NSLog(@"blaabloo %@",urlString);
    // if next page webview, load it here, otherwise open next page with already initialized destPP
    
    if(!(destPP != nil && [[destPP pageURL] containsString:urlString])){
        destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:urlString];
    }
    if( ! ([[destPP getPageType] isEqualToString:@"home-page"] || [[destPP getPageType] isEqualToString:@"brand-review"])){
        if([urlString containsString:@"?asset_origin=axiom"]){
            return YES;
        }else{
            urlString = [NSString stringWithFormat:@"%@?asset_origin=axiom",urlString];
            NSURL *url2 = [NSURL URLWithString:urlString];
            NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
            [_webView loadRequest:request2];
            return NO;
        }
    }
    else{
        //if url contains "online-casinoes-canada.ca" && url NOT contains "links", then it's app page.
        if([urlString containsString:[[GlobalVars sharedInstance] websiteURL]] &&  ! [urlString containsString:globals.redirectionTrigger]){
            [_nav navigateWithItemID:-42 WithURL:urlString WithURLsDict:nil WithSourceVC:self WithInitializedDestPP:nil];
            return NO;
        }
    }
    return YES;
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
    NSString *urlString = _pp.pageURL;
    if(![urlString containsString:@"?asset_origin=axiom"]){
        urlString = [NSString stringWithFormat:@"%@?asset_origin=axiom",urlString];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *rq =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:rq];
}


-(void)initTabBar{
    self.tabbarElements = [self.pp getTabBarElements];
    if(self.tabbarElements == nil){
        return;
    }
    _tags2URLs = [[NSMutableDictionary alloc] init];
    NSMutableArray *tabBarArray;
    int i;
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
    _tabBar.layer.borderWidth = 0;
}


//Handle tabBar clicks
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //On homepage, homepage click does nothing
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
    NSString *theMessage = _pp.pageURL;
    NSArray *items = @[theMessage];
    
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




#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}


@end
