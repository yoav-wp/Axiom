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
#import <UIKit/UIKit.h>

@implementation PalconParser

-(void) initWithFullURL:(NSString *)fullURL{
    NSString *arrangedURL;
    if(! [[fullURL substringFromIndex:fullURL.length-1] isEqualToString:@"/"])
        arrangedURL = [fullURL stringByAppendingString:@"/"];
    self.urlWithQueryString = [arrangedURL stringByAppendingString:@"?context_to_json=1"];
    self.pageURL = fullURL;
    [self initDataDictionary];
}

-(void)initDataDictionary{
    NSError *theError = nil;
    NSLog(@"pp - starting page download download");
    NSData *theJSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlWithQueryString]];
    self.pageDataDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    NSLog(@"pp - finished page download");
}

-(NSString *)getPageType{
//    NSLog(@"file %@",self.pageDataDictionary);
    return [self.pageDataDictionary valueForKey:@"page_type"];
}

-(NSString *)homepageGetAppTitle{
    return [self.pageDataDictionary valueForKey:@"app_title"];
}

-(NSString *)homePageGetTableTitle{
    NSDictionary *dict = [self.pageDataDictionary valueForKey:@"native_app_widget_1"];
    return [dict valueForKey:@"widget_header"];
}

-(NSString *)homepageGetFirstWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"app_intro"];
    
    return baseString;
}
-(NSString *)homepageGetSecondWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"app_content_text_1"];
    
    return baseString;
}

-(NSString *)brandReviewGetWysiwyg{
    NSString *s = [self.pageDataDictionary valueForKey:@"app_intro"];
    return s;
}

-(NSArray *)brandReviewGetRatingDetails{
    NSMutableArray *ar = [self.pageDataDictionary valueForKey:@"rating_details"];
    [ar removeObjectAtIndex:ar.count-1];
    [ar addObject:[self.pageDataDictionary valueForKey:@"avg_rating"]];
    return ar;
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
                                      [_pageDataDictionary valueForKey:@"trans_active_since"],@"active_since_key",
                                      [_pageDataDictionary valueForKey:@"year_established"],@"active_since_value",
                                      [_pageDataDictionary valueForKey:@"trans_support"],@"support_key",
                                      [_pageDataDictionary valueForKey:@"support_email"],@"support_value",
                                      [_pageDataDictionary valueForKey:@"trans_payment_methods"],@"payment_key",
                                      nil];
    return infosDict;
    
}

-(NSString *)brandReviewGetSecondTabWysiwyg{
    return [_pageDataDictionary valueForKey:@"app_review"];
}

-(NSMutableArray *)getBrandReviewScreenshots{
    
    NSMutableArray *screenshots = [self.pageDataDictionary valueForKey:@"screenshots"];
    return screenshots;
}


//for now - private method to get the tabs (used in brandReviewGetSecondTabWysiwyg)
-(NSMutableArray *)getBrandReviewTabs{
    NSMutableArray *tabs;
    for (id key in self.pageDataDictionary) {
        if([key isEqualToString:@"tabs"]){
            tabs = [self.pageDataDictionary objectForKey:key];
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
    return [self.pageDataDictionary valueForKey:@"pay_method"];
}

-(NSArray *)brandReviewGetSoftwareProviders{
    return [self.pageDataDictionary valueForKey:@"sof_providers"];
}

-(NSString *)brandReviewGetTOSWysiwyg{
    return [self.pageDataDictionary valueForKey:@"content_1"];
}

-(NSString *)getIsPageNative{
    return [self.pageDataDictionary valueForKey:@"app_native"];
}

-(NSDictionary *)homepageGetTableWidget{
    return [_pageDataDictionary valueForKey:@"native_app_widget_2"];
}

-(NSArray *)brandReviewGetSegmentText{
    NSArray *ar = [NSArray arrayWithObjects:[_pageDataDictionary valueForKey:@"trans_review_summary"],[_pageDataDictionary valueForKey:@"trans_review_full"],[_pageDataDictionary valueForKey:@"trans_review_info"],nil];
    return ar;
}

-(NSMutableArray *)getTabBarElements{
    GlobalVars *globals = [GlobalVars sharedInstance];
    
    NSURL *url = [[NSURL URLWithString:globals.websiteURL] URLByAppendingPathComponent:@"/wp-content/plugins/wcms_frontend/wcms_ajax_handler.php"];
    url = [NSURL URLWithString:@"?action=get_native_app_tab_bar" relativeToURL:url];
    
//    url = [NSURL URLWithString:@"http://onlinecasinos.expert/tabbar.php"];
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
