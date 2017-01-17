//
//  AppDelegate.m
//  scrollViewTest
//
//  Created by Design Webpals on 26/07/2016.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "AppDelegate.h"
#import <AppsFlyerTracker/AppsFlyerTracker.h>
#import "GlobalVars.h"
#import "MappingFinder.h"
#import "NavigationManager.h"
@import Firebase;

@interface AppDelegate (){
    NSURLSessionDownloadTask *download;
    GlobalVars *globals;
}

@property (nonatomic, strong)NSURLSession *backgroundSession;
@property (nonatomic, retain) MappingFinder *mappingFinder;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initGlobalVars];
    [FIRApp configure];
    [self removeAndDownloadMenu];
    return YES;
}

-(void)initGlobalVars{
    globals = [GlobalVars sharedInstance];
    
#warning Please, put your main variables here below, and remove this line <----
    globals.websiteURL = @"http://www.online-casinos-canada.ca/";
//    globals.websiteURL = @"http://onlinecasinos.expert/homepage.js";
//    globals.websiteURL = @"http://review.des/camilla/";
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"p83XLj9oS5NU6xzdjYGJyF";
    [AppsFlyerTracker sharedTracker].appleAppID = @"1173806600";
    
   
    
    
    if(! [[globals.websiteURL substringFromIndex:globals.websiteURL.length-1] isEqualToString:@"/"]){
        NSLog(@"missing trainling slash");
        globals.websiteURL = [globals.websiteURL stringByAppendingString:@"/"];
    }
    [AppsFlyerTracker sharedTracker].delegate = self;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    NSLog(@"continueUserActivity: page: %@",userActivity.webpageURL);
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]){
        NSURL *url = userActivity.webpageURL;
        NSDictionary *aDict=[NSDictionary dictionaryWithObject:url.absoluteString forKey:@"urlToLoad"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationRequestFromAppDel" object:Nil userInfo:aDict];
    }
    return YES;
}


-(void)onConversionDataReceived:(NSDictionary*) installData {
    
    id status = [installData objectForKey:@"af_status"];
    id source = [installData objectForKey:@"media_source"];
    id campaign = [installData objectForKey:@"campaign"];
    id campaign_id = [installData objectForKey:@"campaign_id"];
    id siteid = [installData objectForKey:@"af_siteid"];
    NSString * appID = [AppsFlyerTracker sharedTracker].appleAppID;
    
    MappingFinder *st = [MappingFinder getMFObject];
    [st initWithStatus:status source:source campaign:campaign app_id:appID campaign_id:campaign_id siteid:siteid];
    NSLog(@"all AppsFlyer params: status:%@, source:%@, campaign:%@, campaign_id(fb):%@,site_id:%@",status,source,campaign,campaign_id,siteid);
    
    NSLog(@"AF ?? status : %@", status);
    if([status isEqualToString:@"Non-organic"]) {
        
        id sourceID = [installData objectForKey:@"media_source"];
        
        id campaign = [installData objectForKey:@"campaign"];
        
        NSString* userId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
        
        NSLog(@"This is a none organic install. Media source: %@  Campaign: %@ uid: %@",sourceID,campaign,userId);
        
        //yoav mappingFinder
    } else if([status isEqualToString:@"Organic"]) {
        NSString* userId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
        NSLog(@"This is an organic install. %@",userId);
    }
}


-(void)applicationDidBecomeActive:(UIApplication *)application
{
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





//Remove and redownload the menu on startup
-(void)removeAndDownloadMenu{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docs path %@", documentsPath);
    //append file name to path
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"menu.plist"];
    NSError *error;
    //remove the file
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if(success) {
        NSLog(@"successfully removed");
    }
    else{
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    //prepare for downloading menu
    NSURLSessionConfiguration *backgroundConfigurationObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"myBackgroundSessionIdentifier"];
    
    _backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfigurationObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //create the download task and run it
    if(download == nil){
        NSURL *url = [[NSURL URLWithString:globals.websiteURL] URLByAppendingPathComponent:@"/wp-content/plugins/wcms_frontend/wcms_ajax_handler.php"];
        url = [NSURL URLWithString:@"?action=get_native_app_nav_menu" relativeToURL:url];
        download = [_backgroundSession downloadTaskWithURL:url];
        [download resume];
    }

}




-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"menu.plist"]];
    
    NSError *error = nil;
    
    //if file exists
    if ([fileManager fileExistsAtPath:[destinationURL path]]){
        [fileManager replaceItemAtURL:destinationURL withItemAtURL:destinationURL backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:&error];
        //Show file for debug
//        [self showFile:[destinationURL path]];
    }else{
        //if moving success
        if ([fileManager moveItemAtURL:location toURL:destinationURL error:&error]) {
            //Show file for debug
//            [self showFile:[destinationURL path]];
        }else{
            NSLog(@"An error has occurred when moving the file: %@",[error localizedDescription]);
        }
    }
    
    
}

-(void)showFile:(NSString*)path{
    // Check if the file exists
    BOOL isFound = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isFound) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSLog(@" \n\n SHOWING FILE %@\n\n",data);
    }
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"bytes written %lld / %lld ",totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"Download is resumed successfully");
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    download = nil;
    if (error) {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
}


@end
