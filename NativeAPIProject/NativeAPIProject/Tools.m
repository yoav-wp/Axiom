//
//  Tools.m
//  NativeAPIProject
//
//  Created by Nir Gaiger on 12/20/16.
//  Copyright © 2016 Domain Planet Limited. All rights reserved.
//

#import "Tools.h"

@implementation Tools

static int number = 1;

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSString *)getDefaultWysiwygCSSwithFontSize:(NSString *)fontSize{
    NSString *style = [NSString stringWithFormat:@"<style>h1{color:red;}span{font-family:Montserrat;color:blue;font-size:%@;}</style>",fontSize];
    return style;
}


@end
