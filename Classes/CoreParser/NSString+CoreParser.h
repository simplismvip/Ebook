//
//  NSString+CoreParser.h
//  JMEpubReader
//
//  Created by JunMing on 2021/4/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (CoreParser)
- (NSMutableAttributedString *)parserEpub:(NSString *)basePath spacing:(CGFloat)spacing font:(UIFont *)font;
- (UIFont *)fontWithSize:(NSInteger)fontSize;
@end

NS_ASSUME_NONNULL_END
