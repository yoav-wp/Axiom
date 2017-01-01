//
//  PalconParser.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/15/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalconParser : NSObject
@property (nonatomic, strong) NSString *urlWithQueryString;
@property (nonatomic, strong) NSString *pageURL;
@property (nonatomic, strong) NSDictionary *pageDataDictionary;

-(void) initWithFullURL:(NSString *)fullURL;
-(NSString *)homepageGetFirstWysiwyg;
-(NSString *)homepageGetSecondWysiwyg;
-(NSArray *)categoryGetCarousel;
-(NSString *)homepageGetAppTitle;
-(NSString *)getPageType;
-(NSMutableArray *)getTabBarElements;
-(NSString *)brandReviewGetWysiwyg;
-(NSString *)brandReviewGetSecondTabWysiwyg;
-(NSMutableArray *)getBrandReviewScreenshots;
-(NSArray *)brandReviewGetPaymentMethods;
-(NSArray *)brandReviewGetSoftwareProviders;
-(NSString *)brandReviewGetTOSWysiwyg;
-(NSString *)homePageGetTableTitle;
-(NSString *)getIsPageNative;
-(NSDictionary *)homepageGetTableWidget;
-(NSArray *)brandReviewGetSegmentText;


@end
