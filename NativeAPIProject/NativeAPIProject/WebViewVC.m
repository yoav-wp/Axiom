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

@interface WebViewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end


static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewdidload");
    
    self.tabBar.selectedItem= self.tabBar.items[2];
    self.revealViewController.rightViewRevealOverdraw=4;
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    NSURLRequest *rq =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:rq];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 1){
//        self.tabBar.selectedItem= self.tabBar.items[5];
        [self.revealViewController rightRevealToggle:self];
    }
    if (item.tag == 5){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
        
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
        [segue perform];
    }
    if (item.tag == 3){
    }
    if (item.tag == 4){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
        
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:self destination:vc];
        [segue perform];
    }
}


#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}


@end
