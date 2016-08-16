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
@property (nonatomic, strong) NSData *pageData;

+(PalconParser *)getPP;
-(void) reinitWithFullURL:(NSString *)fullURL;
-(NSString *)homepageGetFirstWysiwyg;
-(NSMutableArray *)categoryGetCarousel;



@end
