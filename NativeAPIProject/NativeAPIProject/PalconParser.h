//
//  PalconParser.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/15/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalconParser : NSObject
@property (nonatomic, strong) NSString *fullURL;
@property (nonatomic, strong) NSDictionary *pageDataDictionary;

-(void) initWithFullURL:(NSString *)fullURL;
-(NSString *)homepageGetFirstWysiwyg;
-(NSString *)homepageGetSecondWysiwyg;
-(NSMutableArray *)categoryGetCarousel;
-(NSString *)getPageType;
-(NSMutableArray *)getTabBarElements;
-(NSString *)getBaseURL;
-(NSString *)brandReviewGetWysiwyg;
-(NSString *)brandReviewGetSecondTabWysiwyg;


@end
