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
    
    self.urlWithQueryString = [fullURL stringByAppendingString:@"?context_to_json=1"];
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


-(NSString *)homepageGetFirstWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"introduction"];
    
    return baseString;
}

-(NSString *)homePageGetTableTitle{
    return [self.pageDataDictionary valueForKey:@"page_title"];
}

-(NSString *)homepageGetSecondWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"content_text_2"];
    
    return baseString;
}

-(NSString *)brandReviewGetWysiwyg{
    NSString *s = [self.pageDataDictionary valueForKey:@"first_wysiwyg"];
    return s;
}


-(NSString *)brandReviewGetSecondTabWysiwyg{
    return [_pageDataDictionary valueForKey:@"content_text_2"];
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


-(NSArray *)homepageGetTableWidget{
    return [[_pageDataDictionary valueForKey:@"native_app_widget_2"] valueForKey:@"widgets_arr"];
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
