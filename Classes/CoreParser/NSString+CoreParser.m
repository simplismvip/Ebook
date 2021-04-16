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

- (NSMutableAttributedString *)parserEpub:(NSURL *)baseUrl spacing:(CGFloat)spacing font:(UIFont *)font {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            // 需要先进行一次解码
            NSURL *imaUrl = [baseUrl URLByAppendingPathComponent:img];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imaUrl]];
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
                [text appendAttributedString:[self matcheUrls:conText font:font]];
            }
        }
    }
    return text;
}

// 正则匹配网址
- (NSMutableAttributedString *)matcheUrls:(NSMutableAttributedString *)conText font:(UIFont *)font {
    NSString *pattern = @"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    if (regex) {
        NSArray *allMatches = [regex matchesInString:conText.string options:NSMatchingReportCompletion range: NSMakeRange(0, conText.string.length)];
        for (NSTextCheckingResult *match in allMatches) {
            NSString *substrinsgForMatch2 = [conText.string substringWithRange: match.range];
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:substrinsgForMatch2];
            // 利用YYText设置一些文本属性
            one.yy_underlineStyle = NSUnderlineStyleSingle;
            one.yy_color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
            one.yy_font = font;
            YYTextBorder *border = [YYTextBorder new];
            border.cornerRadius = 3;
            border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
            border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBorder:border];
            [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
            [conText replaceCharactersInRange:match.range withAttributedString:one];
        }
    }
    return conText;
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
