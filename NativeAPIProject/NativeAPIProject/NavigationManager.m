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
#import "MappingFinder.h"
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
    
    //These are clicks from a wysiwyg or the main menu
    if(tag == -42 && destURL){
        NSLog(@"tag -42 %@",destURL);
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:destURL];
        NSLog(@"nav manager : this is pp dict :%@",destPP.pageDataDictionary);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        if([[destPP getIsPageNative] isEqualToString:@"wrapped"]){
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        if([[destPP getIsPageNative] isEqualToString:@"exclude"]){
            //send to safari
            NSURL *excludeCaseURL = [NSURL URLWithString:destURL];
            [[UIApplication sharedApplication] openURL:excludeCaseURL options:@{} completionHandler:nil];
            return;
        }
        
        //if page-type is nil, send to webview
        if([destPP getPageType] == nil){
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        else if([[destPP getPageType]isEqualToString:@"home-page"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        else if([[destPP getPageType]isEqualToString:@"webview_page"]){
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        else if([[destPP getPageType]isEqualToString:@"category_page"]){
//            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
//            vc.pp = destPP;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
        }
        else if([[destPP getPageType]isEqualToString:@"brand-review"]){
            BrandReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
            vc.pp = destPP;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        else if([[destPP getPageType]isEqualToString:@"game_review"]){
//            GameReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:gameRevID];
//            vc.pp = destPP;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
        }
        //if page contains unknown page type - open webview
        else{
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
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
        NSString *targetURL = [tags2URLs objectForKey:[NSNumber numberWithInteger:tag]];
        PalconParser *destPP = [[PalconParser alloc] init];
        [destPP initWithFullURL:targetURL];
        
        
        //if page type is nil
        if([destPP getPageType] == nil){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
        }
        
        if([[destPP getIsPageNative] isEqualToString:@"wrapped"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        if([[destPP getIsPageNative] isEqualToString:@"excluse"]){
            //send to safari
            NSURL *excludeCaseURL = [NSURL URLWithString:targetURL];
            [[UIApplication sharedApplication] openURL:excludeCaseURL options:@{} completionHandler:nil];
            return;
        }
        
        else if([[destPP getPageType]isEqualToString:@"brand-review"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            BrandReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        else if([[destPP getPageType]isEqualToString:@"product-review"]){
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//            GameReviewVC *vc = [storyboard instantiateViewControllerWithIdentifier:brandRevID];
//            vc.pp = destPP;
//            vc.activeTab = tag;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
        }
        else if([[destPP getPageType]isEqualToString:@"webview_page"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        else if([[destPP getPageType]isEqualToString:@"home-page"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
        else if([[destPP getPageType]isEqualToString:@"category_page"]){
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//            CategoryVC *vc = [storyboard instantiateViewControllerWithIdentifier:categoryID];
//            vc.pp = destPP;
//            vc.activeTab = tag;
//            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
//            [segue perform];
        }
        //if unknown page-type
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WebViewVC *vc = [storyboard instantiateViewControllerWithIdentifier:webviewID];
            vc.pp = destPP;
            vc.activeTab = tag;
            SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
            [segue perform];
            return;
        }
    }
}

-(void)navigateToHomepageWithVC:(UIViewController *)sourceVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:homepageID];
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ANY_ID" source:sourceVC destination:vc];
    [segue perform];
}

-(void)navigateToAffLink:(NSString *)urlStr{
    
    NSString *transformedUrlStr;
    int slashCount = 0;
    int i;
    for(i = 0; i < urlStr.length; i++){
        if([urlStr characterAtIndex:i] == '/'){
            slashCount++;
        }
        if(slashCount == 4 && [urlStr characterAtIndex:i] == '/'){
            break;
        }
    }
    
    NSLog(@"i is %d",i);
    transformedUrlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(0, i) withString:@"http://www.mappingfinder.com/go"];
    
    NSURL *url = [NSURL URLWithString:transformedUrlStr];
    MappingFinder *st = [MappingFinder getMFObject];
    url= [st makeURL:url trigger:@"go"];
    NSLog(@"url after navtoafflink %@",url);
    
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}



@end
