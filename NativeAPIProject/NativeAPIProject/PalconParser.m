//
//  PalconParser.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/15/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "PalconParser.h"
#import "CJSONDeserializer.h"
#import "GlobalVars.h"
#import "InternetReachability.h"
#import <UIKit/UIKit.h>

@implementation PalconParser{
    GlobalVars *globals;
}

-(void) initWithFullURL:(NSString *)fullURL{
    NSString *arrangedURL;
    NSURL *url = [NSURL URLWithString:fullURL];
    url = [NSURL URLWithString:@"?context_to_json=1" relativeToURL:url];
    arrangedURL = url.absoluteString;
    
    globals = [GlobalVars sharedInstance];
    NSLog(@"arranged url : %@",arrangedURL);
    _urlWithQueryString = arrangedURL;
    _pageURL = fullURL;
    if ([[InternetReachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        _pageDataDictionary = nil;
    }
    else
    {
        [self initDataDictionary];
    }
}

-(void)initDataDictionary{
    NSError *theError = nil;
    NSError *downloadError = nil;
    NSLog(@"pp - starting page download");
    NSData *theJSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlWithQueryString] options:NSDataReadingUncached error:&downloadError];
    _pageDataDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    NSLog(@"pp - finished page download : %@",_pageDataDictionary);
}

-(NSString *)getPageType{

    return [_pageDataDictionary valueForKey:@"page_type"];
}

-(NSString *)homepageGetAppTitle{
    return [_pageDataDictionary valueForKey:@"app_title"];
}

-(NSString *)homePageGetTableTitle{
    NSDictionary *dict = [_pageDataDictionary valueForKey:@"native_app_widget_1"];
    return [dict valueForKey:@"widget_header"];
}

-(NSString *)homepageGetFirstWysiwyg {
    NSString *baseString = [_pageDataDictionary valueForKey:@"app_intro"];
    
    return baseString;
}
-(NSString *)homepageGetSecondWysiwyg {
    NSString *baseString = [_pageDataDictionary valueForKey:@"app_content_text_1"];
    
    return baseString;
}


-(NSString *)brandReviewGetWysiwyg{
    NSString *s = [_pageDataDictionary valueForKey:@"app_intro"];
    return s;
}

-(NSArray *)brandReviewGetRatingDetails{
    NSMutableArray *ar = [_pageDataDictionary valueForKey:@"app_rating_details"];
    [ar removeObjectAtIndex:ar.count-1];
    
    NSString *lastAvgRating = [[_pageDataDictionary valueForKey:@"app_avg_rating"] valueForKey:@"app_rating"];
    NSDictionary *lastObject = [[NSDictionary alloc] initWithObjectsAndKeys:[_pageDataDictionary valueForKey:@"translation10"],@"app_rating_title",lastAvgRating,@"app_rating", nil];
    [ar addObject:lastObject];
    return ar;
}

-(NSString *)brandReviewGetBrandLogo{
    return [_pageDataDictionary valueForKey:@"main_brand_logo_src"];
}
-(NSString *)brandReviewGetBrandName{
    return [_pageDataDictionary valueForKey:@"brand_name"];
}

-(NSString *)brandReviewGetBonusText{
    return [_pageDataDictionary valueForKey:@"bonus_text"];
}

-(NSString *)brandReviewGetBrandRating{
    return [_pageDataDictionary valueForKey:@"rating_s"];
}

-(NSString *)brandReviewGetAffiliateURL{
    NSString *appLink = [_pageDataDictionary valueForKey:@"brand_app_link"];
    if([_pageDataDictionary valueForKey:@"override_brands_default_link"]  != nil && [[_pageDataDictionary valueForKey:@"override_brands_default_link"] containsString:@"1"] && appLink.length > 6){
        return appLink;
    }
    return [_pageDataDictionary valueForKey:@"affiliate_url"];
}

-(NSString *)brandNameGetClaimButtonText{
    return [_pageDataDictionary valueForKey:@"trans_playnow"];
}

/**
 Returns keys - values names for basic brand infos : website_key, website_value, software_key, active_since_key, active_since_value, support_key, support_value, payment_key

 @return a dict
 */
-(NSDictionary *)brandReviewGetBasicBrandInfoDict{
    NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [_pageDataDictionary valueForKey:@"trans_website"],@"website_key",
                                      [_pageDataDictionary valueForKey:@"website"],@"website_value",
                                      [_pageDataDictionary valueForKey:@"trans_software"],@"software_key",
                                      [_pageDataDictionary valueForKey:@"trans_payment_methods"],@"payment_key",
                                      [_pageDataDictionary valueForKey:@"trans_active_since"],@"active_since_key",
                                      [_pageDataDictionary valueForKey:@"year_established"],@"active_since_value",
                                      [_pageDataDictionary valueForKey:@"trans_support"],@"support_key",
                                      [_pageDataDictionary valueForKey:@"support_email"],@"support_value",
                                      nil];
    
    if([infosDict valueForKey:@"year_established"] == nil){
        [infosDict setValue:@"" forKey:@"year_established"];
    }
    
    if([infosDict valueForKey:@"website"] == nil){
        [infosDict setValue:@"" forKey:@"website"];
    }
    
    if([infosDict valueForKey:@"support_value"] == nil){
        [infosDict setValue:@"" forKey:@"support_value"];
    }
    
    
    NSLog(@"gggggg %@",infosDict);
    return infosDict;
    
}

-(NSString *)brandReviewGetSecondTabWysiwyg{
    return [_pageDataDictionary valueForKey:@"app_review"];
}

-(NSMutableArray *)getBrandReviewScreenshots{
    
    NSMutableArray *screenshots = [_pageDataDictionary valueForKey:@"screenshots"];
    return screenshots;
}


//for now - private method to get the tabs (used in brandReviewGetSecondTabWysiwyg)
-(NSMutableArray *)getBrandReviewTabs{
    NSMutableArray *tabs;
    for (id key in _pageDataDictionary) {
        if([key isEqualToString:@"tabs"]){
            tabs = [_pageDataDictionary objectForKey:key];
            break;
        }
    }
    return tabs;
}


-(NSArray *)categoryGetCarousel {
    NSArray *arr = [[_pageDataDictionary valueForKey:@"native_app_widget_1"] valueForKey:@"widgets_arr"];
    return arr;
}

-(NSArray *)brandReviewGetPaymentMethods{
    return [_pageDataDictionary valueForKey:@"pay_method"];
}

-(NSArray *)brandReviewGetSoftwareProviders{
    return [_pageDataDictionary valueForKey:@"sof_providers"];
}

-(NSString *)brandReviewGetTOSWysiwyg{
    return [_pageDataDictionary valueForKey:@"app_info"];
}

-(NSString *)getIsPageNative{
    return [_pageDataDictionary valueForKey:@"native_app"];
}

-(NSDictionary *)homepageGetTableWidget{
    return [_pageDataDictionary valueForKey:@"native_app_widget_2"];
}

-(NSArray *)brandReviewGetSegmentText{
    NSArray *ar = [NSArray arrayWithObjects:[_pageDataDictionary valueForKey:@"trans_review_summary"],[_pageDataDictionary valueForKey:@"trans_review_full"],[_pageDataDictionary valueForKey:@"trans_review_info"],nil];
    if(ar.count == 3){
        return ar;
    }else{
        return @[@"Summary",@"Full Review",@"Brand Info"];
    }
    
}


-(NSDictionary *)homepageGetBannerDataDict{
    NSURL *url = [[NSURL URLWithString:globals.websiteURL] URLByAppendingPathComponent:@"/wp-content/plugins/wcms_frontend/wcms_ajax_handler.php"];
    url = [NSURL URLWithString:@"?action=get_native_app_general_settings" relativeToURL:url];
    NSError *theError = nil;
    NSLog(@"starting banner download");
    NSData *theJSONData = [NSData dataWithContentsOfURL:url];
    NSLog(@"finished banner download");
    NSDictionary *bannerDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    return bannerDict;
}


-(NSMutableArray *)getTabBarElements{
    if ([[InternetReachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        return nil;
    }
    NSURL *url = [[NSURL URLWithString:globals.websiteURL] URLByAppendingPathComponent:@"/wp-content/plugins/wcms_frontend/wcms_ajax_handler.php"];
    url = [NSURL URLWithString:@"?action=get_native_app_tab_bar" relativeToURL:url];
    
    NSError *theError = nil;
    NSLog(@"starting tabbar download");
    NSData *theJSONData = [NSData dataWithContentsOfURL:url];
    NSLog(@"finished tabbar download");
    NSDictionary *tabbarDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    NSMutableArray *tabbarArray;
    for (id key in tabbarDict) {
        if([key isEqualToString:@"tabbar"]){
            tabbarArray =[tabbarDict objectForKey:key];
            break;
        }
    }
    return tabbarArray;
}

@end
