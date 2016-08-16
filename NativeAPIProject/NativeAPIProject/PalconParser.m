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

static BOOL initialized = NO;
static PalconParser *sharedSingleton;



+(PalconParser *) getPP{
    @synchronized (self) {
        if(!initialized){
            sharedSingleton = [[PalconParser alloc] init];
        }
        return sharedSingleton;
    }
}

-(void) initWithWebsite:(NSString *)websiteURL{
    [self someJsonTests];
    if(!initialized){
        self.websiteURL = websiteURL;
        initialized = YES;
    }
}


-(void) someJsonTests{
    NSURL *url = [NSURL URLWithString:@"http://www.onlinecasinos.expert/homepage.js"];
    //create a NSData file from url.
    NSData *myData = [NSData dataWithContentsOfURL:url];
    //get String value of the NSData.
    NSString * myString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
//    NSLog(@"data : %@",myString);
    
    NSError *theError = nil;
    NSData *theJSONData = myData;
//
//    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
//    
//    //get resultCount value (depth 0 of the json)
//    NSString *baseString = [dict valueForKey:@"page_url"];
//    
//    NSLog(@"resultCount = %@", baseString );
//    
//    //get results->artistId value (depth 1 of the json)
//    NSString *resString = [dict valueForKey:@"results"];
//    NSLog(@"artistId = %@", [resString valueForKey:@"artistId"] );
}




-(NSString *)homepageGetFirstWysiwyg {
    NSURL *url = [NSURL URLWithString:@"http://www.onlinecasinos.expert/homepage.js"];
    //create a NSData file from url.
    NSData *myData = [NSData dataWithContentsOfURL:url];
    //get String value of the NSData.
    NSString * myString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSError *theError = nil;
    NSData *theJSONData = myData;
    //
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    
    //get resultCount value (depth 0 of the json)
    NSString *baseString = [dict valueForKey:@"first_wysiwyg"];
    return baseString;
}

-(NSMutableArray *)categoryGetCarouselForPage:(NSString *)pageURL {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",pageURL]];
    //create a NSData file from url.
    NSData *myData = [NSData dataWithContentsOfURL:url];
    
    NSError *theError = nil;
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:&theError];
    
    //get resultCount value (depth 0 of the json)
    NSString *testString = [dict valueForKey:@"page_url"];
    NSLog(@"page_url = %@", testString );
    
    //	lets try foreach product display timestamp
    
    NSMutableArray *carousel;
    for(id key in dict){
        NSLog(@"key: %@, value: %@",key,[dict objectForKey:key]);
        if([key isEqualToString:@"carousel"]){
            //			NSLog(@" value class: %@", [dict[key] class]);
            carousel = [dict objectForKey:key];
            break;
        }
    }
    
    return carousel;
}


















@end
