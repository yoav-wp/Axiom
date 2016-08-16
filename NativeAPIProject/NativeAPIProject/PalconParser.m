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

//static BOOL initialized = NO;
static PalconParser *sharedSingleton;


//
//-(PalconParser *) getPP{
//    @synchronized (self) {
//        if(!initialized){
//            sharedSingleton = [[PalconParser alloc] init];
//        }
//        return sharedSingleton;
//    }
//}

-(void) reinitWithFullURL:(NSString *)fullURL{
        self.fullURL = fullURL;
        [self initDataDictionary];
}

-(void)initDataDictionary{
    NSError *theError = nil;
    NSData *theJSONData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.fullURL]];
    self.pageDataDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
}

-(NSString *)getPageType{
    NSLog(@"file %@",self.pageDataDictionary);
    return [self.pageDataDictionary valueForKey:@"page_type"];
}


-(NSString *)homepageGetFirstWysiwyg {
    //get resultCount value (depth 0 of the json)
    NSString *baseString = [self.pageDataDictionary valueForKey:@"first_wysiwyg"];
    
    return baseString;
}

-(NSString *)homepageGetSecondWysiwyg {
    //get resultCount value (depth 0 of the json)
    NSString *baseString = [self.pageDataDictionary valueForKey:@"second_wysiwyg"];
    
    return baseString;
}

-(NSMutableArray *)categoryGetCarousel {
    NSMutableArray *carousel;
    for(id key in self.pageDataDictionary){
//        NSLog(@"key: %@, value: %@",key,[dict objectForKey:key]);
        if([key isEqualToString:@"carousel"]){
            //			NSLog(@" value class: %@", [dict[key] class]);
            carousel = [self.pageDataDictionary objectForKey:key];
            break;
        }
    }
    
    return carousel;
}


















@end
