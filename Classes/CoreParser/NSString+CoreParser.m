//
//  NSString+CoreParser.m
//  JMEpubReader
//
//  Created by JunMing on 2021/4/14.
//

#import "NSString+CoreParser.h"
#import "YYText.h"
#import <CoreText/CoreText.h>

@implementation NSString (CoreParser)

- (NSMutableAttributedString *)parserEpub:(NSString *)basePath spacing:(CGFloat)spacing font:(UIFont *)font {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            NSLog(@"⚠️⚠️⚠️-img:%@",img);
            
//            NSString *imaStr = [basePath stringByAppendingPathComponent:@"epubtestpng.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:basePath];
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
            if (image.size.width > width) {
                CGFloat rate = image.size.width / width;
                image = [UIImage imageWithCGImage:image.CGImage scale:rate orientation:UIImageOrientationUp];
            }
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachText];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
            [scanner scanString:@"</img>" intoString:NULL];
        } else{
            NSString *content;
            if ([scanner scanUpToString:@"<img>" intoString:&content]) {
                NSMutableAttributedString *conText = [[NSMutableAttributedString alloc] initWithString:content];
                conText.yy_lineSpacing = spacing;
                conText.yy_font = font;
                conText.yy_firstLineHeadIndent = 20;
                [text appendAttributedString:conText];
            }
        }
    }
    return text;
}

- (UIFont *)fontWithSize:(NSInteger)fontSize {
    NSURL * url = [[NSURL alloc] initFileURLWithPath:self];
    UIFont * font = [self customFontWithFontUrl:url size:fontSize];
    return font;
}

- (UIFont*)customFontWithFontUrl:(NSURL*)customFontUrl size:(CGFloat)size {
    NSURL *fontUrl = customFontUrl;
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    bool isSuccess = CTFontManagerRegisterGraphicsFont(fontRef, &error);
    if(!isSuccess){
        //如果注册失败，则不使用
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

@end
