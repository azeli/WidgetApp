//
//  FileTransiting.h
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WidgetTransiting <NSObject>

- (BOOL)writeMessageObject:(nullable id<NSCoding>)messageObject forIdentifier:(NSString *)identifier;

- (nullable id<NSCoding>)messageObjectForIdentifier:(nullable NSString *)identifier;

@end

@protocol WidgetTransitingDelegate <NSObject>

- (void)notifyListenerForMessageWithIdentifier:(nullable NSString *)identifier message:(nullable id<NSCoding>)message;

@end

@interface WidgetFileTransiting : NSObject <WidgetTransiting>{
 @private
    NSString *_applicationGroupIdentifier;
    NSString *_directory;
    NSFileManager *fileManager;
}

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory NS_DESIGNATED_INITIALIZER;

- (nullable NSString *)messagePassingDirectoryPath;

- (nullable NSString *)filePathForIdentifier:(nullable NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
