//
//  WebViewVC.m
//  scrollViewTest
//
//  Created by Nir Gaiger on 8/10/16.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "WebViewVC.h"
#import "SWRevealViewController.h"

@interface WebViewVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITabBarItem *menuButton;

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    if (item.tag == 2){
        [self.revealViewController rightRevealToggle:self];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
