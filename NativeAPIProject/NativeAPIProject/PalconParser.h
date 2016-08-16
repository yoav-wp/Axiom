//
//  PalconParser.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 8/15/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalconParser : NSObject
@property (nonatomic, strong) NSString *websiteURL;

+(PalconParser *)getPP;
-(void) initWithWebsite:(NSString *)websiteURL;
-(NSString *)homepageGetFirstWysiwyg;
-(NSMutableArray *)categoryGetCarouselForPage:(NSString *)pageURL;



@end
