//
//  NSString+Extension.m
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Size)

- (CGSize) sizeWithFont:(UIFont *) font
{
    
    return [self sizeWithFont:font :MAXFLOAT];
}

- (CGSize) sizeWithFont:(UIFont *)font :(CGFloat) width
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (NSString *)encodeToPercentEscapeString
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(__bridge CFStringRef)self,NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    CFRelease((__bridge CFTypeRef)(outputStr));
    return outputStr;
}


- (NSString *)decodeFromPercentEscapeString
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)dateStringFromtYYYYMMDD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

-(NSString*) getTheCorrect
{
    NSString *str = self;
    while ([str hasPrefix:@"0"]){
        str = [str substringFromIndex:1];
    }
    return str;
}

-(id)JSONValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
