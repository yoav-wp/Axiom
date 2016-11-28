//
//  PalconParser.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/15/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "PalconParser.h"
#import "CJSONDeserializer.h"

@implementation PalconParser

-(void) initWithFullURL:(NSString *)fullURL{
    
    self.fullURL = [fullURL stringByAppendingString:@"?context_to_json=1"];
    [self initDataDictionary];
}

-(void)initDataDictionary{
    NSError *theError = nil;
    NSData *theJSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.fullURL]];
    self.pageDataDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
}

-(NSString *)getPageType{
//    NSLog(@"file %@",self.pageDataDictionary);
    return [self.pageDataDictionary valueForKey:@"page_type"];
}


-(NSString *)homepageGetFirstWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"introduction_text"];
    
    return baseString;
}

-(NSString *)homepageGetSecondWysiwyg {
    NSString *baseString = [self.pageDataDictionary valueForKey:@"second_wysiwyg"];
    
    return baseString;
}

-(NSString *)brandReviewGetWysiwyg{
    NSString *s = [self.pageDataDictionary valueForKey:@"first_wysiwyg"];
    return s;
}


-(NSString *)brandReviewGetSecondTabWysiwyg{
    NSString *s;
    
    int i = 0;
    NSMutableArray *tabs = [self getBrandReviewTabs];
    for(i = 0; i< tabs.count; i++){
        NSLog(@" yo yo%@ ",[tabs[i] valueForKey:@"id"]);
        if([[tabs[i] valueForKey:@"id"] integerValue] == 2){
            s = [tabs[i] valueForKey:@"wysiwyg"];
            break;
        }
    }
    return s;
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


-(NSMutableArray *)categoryGetCarousel {
    return [self.pageDataDictionary valueForKey:@"carousel"];
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

//ask R&D to have site url in each page, to avoid multiple connections to API
-(NSString *)getBaseURL{
    return [self.pageDataDictionary valueForKey:@"website_url"];
}

-(NSMutableArray *)getTabBarElements{
    NSString *baseURL = [self getBaseURL];
    NSString *tabBarURL = [NSString stringWithFormat:@"%@/tabbar.js",baseURL];
    NSError *theError = nil;
    NSData *theJSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tabBarURL]];
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
