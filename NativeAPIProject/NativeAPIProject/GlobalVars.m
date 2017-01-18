//
//  GlobalVars.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 11/21/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "GlobalVars.h"

@implementation GlobalVars

@synthesize websiteURL = _websiteURL;
@synthesize tagWysiwyg = _tagWysiwyg;
@synthesize homepageID = _homepageID;
@synthesize webviewID = _webviewID;
@synthesize categoryID = _categoryID;
@synthesize redirectionTrigger = _redirectionTrigger;
@synthesize brandRevID = _brandRevID;


+(GlobalVars *)sharedInstance{
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

-(id) init{
    self = [super init];
    if(self){
        _websiteURL = nil;
        _tagWysiwyg = 0;
        _redirectionTrigger = nil;
        _homepageID = nil;
        _webviewID = nil;
        _categoryID = nil;
        _brandRevID = nil;
    }
    return self;
}

@end
