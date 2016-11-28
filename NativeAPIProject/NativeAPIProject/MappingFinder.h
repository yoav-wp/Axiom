//
//  MappingFinder.h
//  Daily_Fantasy_Sports
//
//  Created by Design Webpals on 22/11/2015.
//	
//

#import <Foundation/Foundation.h>

@interface MappingFinder : NSObject

@property (nonatomic, strong) id source;
@property (nonatomic, strong) id campaign;
@property (nonatomic, strong) id status;
@property (nonatomic, strong) id campaign_id;
@property (nonatomic, strong) id siteid;
@property (nonatomic, strong) NSString * trigger;
@property (nonatomic, strong) NSString * app_id;



-(void) initWithStatus:(id)status_ source:(id)source_ campaign:(id)campaign_ app_id:app_id_ campaign_id:(id)campaign_id_ siteid:(id)siteid_;
-(NSURL *) makeURL:(NSURL *)url_ trigger:(NSString *)trigger_;
+(MappingFinder *)getMFObject;


@end
