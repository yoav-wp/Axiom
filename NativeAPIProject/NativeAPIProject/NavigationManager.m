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

/*!
 This is the main navigation function of NavigationManager

 @param tag reserved values: 24 to open homepage, -42 if you have a destURL
 @param destURL destination URL, *required (unless tag is 24)
 @param tags2URLs needed only when (10 < tag < 20)
 @param sourceVC usually self
 */
-(void) navigateWithItemID: (NSInteger) tag WithURL:(NSString *)destURL WithURLsDict: (NSMutableDictionary *)tags2URLs WithSourceVC:(UIViewController *)sourceVC{
    NSLog(@"the tag is : %ld", (long)tag);
    //These are clicks from a wysiwyg
    if(tag == -42 && destURL){
        NSLog(@"tag -42");
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
            //for now :
//            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
//            vc.pp = destPP;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"brand-review"]){
            BrandReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        if([[destPP getPageType]isEqualToString:@"game_review"]){
            //for now :
//            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
//            vc.pp = destPP;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
            GameReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:gameRevID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        //tag 24 is homepage
    }else if (tag == 24){
        NSLog(@"tag 24");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
        SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
        [segue perform];
    }
    //These are clicks from the tabbar (tags 11-20)
    else{
        NSLog(@"tag else");
        NSString *targetURL = [tags2URLs objectForKey:[NSNumber numberWithInteger:tag]];
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:targetURL];
        
        if([[destPP getPageType]isEqualToString:@"brand-review"]){
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
