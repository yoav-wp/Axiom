//
//  GlobalVars.h
//  NativeAPIProject
//
//  Created by Nir Gaiger on 11/21/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject{
    NSString *_websiteURL;
    NSInteger _tagWysiwyg;
    
    NSString *_homepageID; 
    NSString *_webviewID;
    NSString *_categoryID;
    NSString *_brandRevID;
}

+(GlobalVars *)sharedInstance;

@property(strong, nonatomic, readwrite) NSString *websiteURL;
@property(nonatomic, readwrite) NSInteger tagWysiwyg;

@property(strong, nonatomic, readwrite) NSString *homepageID;
@property(strong, nonatomic, readwrite) NSString *webviewID;
@property(strong, nonatomic, readwrite) NSString *categoryID;
@property(strong, nonatomic, readwrite) NSString *brandRevID;


@end
