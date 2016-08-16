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

-(void) reinitWithFullURL:(NSString *)fullURL{
    if(!initialized){
        self.fullURL = fullURL;
        NSLog(@"full url: %@",fullURL);
        NSURL *url = [NSURL URLWithString:fullURL];
        self.pageData = [NSData dataWithContentsOfURL:url];
        initialized = YES;
    }
}

-(NSString *)homepageGetFirstWysiwyg {
    //get String value of the NSData.
    //    NSString * myString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSError *theError = nil;
    NSData *theJSONData = self.pageData;
    //
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    
    //get resultCount value (depth 0 of the json)
    NSString *baseString = [dict valueForKey:@"first_wysiwyg"];
    
    return baseString;
}


-(NSString *)homepageGetSecondWysiwyg {
    //get String value of the NSData.
    //    NSString * myString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSError *theError = nil;
    NSData *theJSONData = self.pageData;
    //
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:theJSONData error:&theError];
    
    //get resultCount value (depth 0 of the json)
    NSString *baseString = [dict valueForKey:@"second_wysiwyg"];
    
    return baseString;
}



-(NSMutableArray *)categoryGetCarousel {
    NSError *theError = nil;
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.pageData error:&theError];
    NSMutableArray *carousel;
    for(id key in dict){
//        NSLog(@"key: %@, value: %@",key,[dict objectForKey:key]);
        if([key isEqualToString:@"carousel"]){
            //			NSLog(@" value class: %@", [dict[key] class]);
            carousel = [dict objectForKey:key];
            break;
        }
    }
    
    return carousel;
}


















@end
