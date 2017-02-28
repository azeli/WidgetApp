//
//  FileManager.h
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetFileTransiting.h"


NS_ASSUME_NONNULL_BEGIN

@interface WidgetFileManager: NSObject <WidgetTransitingDelegate>{
 @private
    NSMutableDictionary *listenerBlocks;
    id <WidgetTransiting> Messenger;
}

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory NS_DESIGNATED_INITIALIZER;

- (void)passMessageObject:(nullable id <NSCoding>)messageObject
               identifier:(nullable NSString *)identifier;

- (nullable id)messageWithIdentifier:(nullable NSString *)identifier;

- (void)listenForMessageWithIdentifier:(nullable NSString *)identifier
                              listener:(nullable void (^)(__nullable id messageObject))listener;

- (void)stopListeningForMessageWithIdentifier:(nullable NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
