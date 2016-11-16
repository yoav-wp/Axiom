//
//  NavigationManager.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 10/5/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "NavigationManager.h"
#import "PalconParser.h"
#import "SWRevealViewController.h"
#import "CategoryVC.h"
#import "WebViewVC.h"
#import "ViewController.h"
#import "BrandReviewVC.h"
#import "GameReviewVC.h"

static NSString * homepageID = @"HomePageSB";
static NSString * webviewID = @"webviewVC";
static NSString * categoryID = @"categoryVC";
static NSString * brandRevID = @"brandRevID";
static NSString * gameRevID = @"gameRevID";
@implementation NavigationManager




//we have: tag ID, pp, tabbarElements (array with button txt, link, img url)
-(void) navigateWithItemID: (NSInteger) tag WithURL:(NSString *)destURL WithURLsDict: (NSMutableDictionary *)tags2URLs WithSourceVC:(UIViewController *)sourceVC{
    NSLog(@"the tag is : %ld", (long)tag);
    //this is for the clicks from the tabbar.
    if(tag == -42 && destURL){
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:destURL];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        if([[destPP getPageType]isEqualToString:@"webview_page"]){
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"category_page"]){
            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"brand_review"]){
            BrandReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"game_review"]){
            GameReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:gameRevID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
    }
    
    //On menu click, action is static - always open menu
    if (tag == 24){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
        [segue perform];
    }
    //this case is for any button click (not from tabbar)
    else{
        NSString *targetURL = [tags2URLs objectForKey:[NSNumber numberWithInteger:tag]];
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:targetURL];
        
        if([[destPP getPageType]isEqualToString:@"brand_review"]){
            NSLog(@"entered WV if");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"webview_page"]){
            NSLog(@"entered WV if");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"category_page"]){
            NSLog(@"entered WV if");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
    }
}



@end
