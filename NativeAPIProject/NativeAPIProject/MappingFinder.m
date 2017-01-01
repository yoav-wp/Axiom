//
//  MappingFinder.m
//  Daily_Fantasy_Sports
//
//  Created by Design Webpals on 22/11/2015.
//
//

#import "MappingFinder.h"

@implementation MappingFinder
static MappingFinder *sharedSingleton;

@synthesize status,source,campaign, app_id, campaign_id, siteid;

static BOOL initialized = NO;

+(void)initialize{
	if(!initialized){
		NSLog(@"MF initialized");
	}
}

-(void) initWithStatus:(id)status_ source:(id)source_ campaign:(id)campaign_ app_id:app_id_ campaign_id:(id)campaign_id_ siteid:(id)siteid_{
	if(!initialized){
		sharedSingleton.status=status_;
		sharedSingleton.campaign=campaign_;
		sharedSingleton.campaign_id=campaign_id_;
		sharedSingleton.app_id=app_id_;
		sharedSingleton.source=source_;
		sharedSingleton.siteid=siteid_;
		initialized = YES;
	}
}


+(MappingFinder *) getMFObject{
	@synchronized (self) {
		if(!initialized){
			sharedSingleton = [[MappingFinder alloc] init];
		}
		return sharedSingleton;
	}
}

-(NSURL *)makeURL:(NSURL *)url_ trigger:(NSString *)trigger {
	NSURL *tempUrl = url_;
	NSLog(@"entered makeURL, status: %@",status);
	
    //case it's a webapp
	if ( [[url_ scheme] isEqualToString:@"gap"] || [[url_ scheme] isEqualToString:@"file"] ) {
		return url_;
	}
	
	if ([status isEqualToString:@"Organic"]){
		NSURLComponents *components = [NSURLComponents componentsWithString:[tempUrl absoluteString]];
		NSURLQueryItem *appID=[NSURLQueryItem queryItemWithName:@"mf_app_id" value:app_id];
		components.queryItems = @[appID];
		NSURL *url = components.URL;
		if ([[url absoluteString] containsString:@"/go/"]){
			return url;
		}
	}else{
		NSURLComponents *components = [NSURLComponents componentsWithString:[tempUrl absoluteString]];
		//if not facebook
		if(campaign_id == nil){
			if(siteid == nil){
				NSURLQueryItem *src=[NSURLQueryItem queryItemWithName:@"mf_source" value:source];
				NSURLQueryItem *appID=[NSURLQueryItem queryItemWithName:@"mf_app_id" value:app_id];
				NSURLQueryItem *cam=[NSURLQueryItem queryItemWithName:@"mf_campaign" value:campaign];
				components.queryItems = @[appID,src,cam];
			}else{
				NSURLQueryItem *src=[NSURLQueryItem queryItemWithName:@"mf_source" value:source];
				NSURLQueryItem *appID=[NSURLQueryItem queryItemWithName:@"mf_app_id" value:app_id];
				NSURLQueryItem *cam=[NSURLQueryItem queryItemWithName:@"mf_campaign" value:campaign];
				NSURLQueryItem *sid=[NSURLQueryItem queryItemWithName:@"mf_siteid" value:campaign];
				components.queryItems = @[appID,src,cam,sid];
			}
		}else{
			//if IS facebook
			//if(siteid == nil){
				NSURLQueryItem *src=[NSURLQueryItem queryItemWithName:@"mf_facebook_id" value:campaign_id];
				NSURLQueryItem *appID=[NSURLQueryItem queryItemWithName:@"mf_app_id" value:app_id];
				NSURLQueryItem *cam=[NSURLQueryItem queryItemWithName:@"mf_campaign" value:campaign];
				components.queryItems = @[appID,src,cam];
			//}
		}

		NSURL *url = components.URL;
	
		if ([[url absoluteString] containsString:@"go"]){
			return url;
		}
	}
	
	return tempUrl;
}

@end
