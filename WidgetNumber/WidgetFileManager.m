//
//  FileManager.m
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "WidgetFileManager.h"

#include <CoreFoundation/CoreFoundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const NotificationName = @"NotificationName";

void wormholeNotificationCallback(CFNotificationCenterRef center,
                                  void *observer,
                                  CFStringRef name,
                                  void const *object,
                                  CFDictionaryRef userInfo);

@interface WidgetFileManager ()

@end

@implementation WidgetFileManager

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterRemoveEveryObserver(center, (__bridge const void *)(self));
}

- (instancetype)init {
    self = [super init];
    return nil;
}

#pragma clang diagnostic pop

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory {
    if (self = [super init]) {
        
        if (NO == [[NSFileManager defaultManager] respondsToSelector:@selector(containerURLForSecurityApplicationGroupIdentifier:)]) {
            return nil;
        }
        
        Messenger = [[WidgetFileTransiting alloc] initWithApplicationGroupIdentifier:[identifier copy]
                                                             optionalDirectory:[directory copy]];
        
        listenerBlocks = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)
                                                     name:NotificationName
                                                   object:self];
    }
    
    return self;
}

#pragma mark - Private Notification Methods

- (void)sendNotificationForMessageWithIdentifier:(nullable NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFDictionaryRef const userInfo = NULL;
    BOOL const deliverImmediately = YES;
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterPostNotification(center, str, NULL, userInfo, deliverImmediately);
}

- (void)registerForNotificationsWithIdentifier:(nullable NSString *)identifier {
    [self unregisterForNotificationsWithIdentifier:identifier];
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterAddObserver(center,
                                    (__bridge const void *)(self),
                                    NotificationCallback,
                                    str,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)unregisterForNotificationsWithIdentifier:(nullable NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterRemoveObserver(center,
                                       (__bridge const void *)(self),
                                       str,
                                       NULL);
}

void NotificationCallback(CFNotificationCenterRef center,
                          void *observer,
                          CFStringRef name,
                          void const *object,
                          CFDictionaryRef userInfo) {
    NSString *identifier = (__bridge NSString *)name;
    NSObject *sender = (__bridge NSObject *)(observer);
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName
                                                        object:sender
                                                      userInfo:@{@"identifier" : identifier}];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *identifier = [userInfo valueForKey:@"identifier"];
    
    if (identifier != nil) {
        id messageObject = [Messenger messageObjectForIdentifier:identifier];
        [self notifyListenerForMessageWithIdentifier:identifier message:messageObject];
    }
}

- (id)listenerBlockForIdentifier:(NSString *)identifier {
    return [listenerBlocks valueForKey:identifier];
}

- (void)notifyListenerForMessageWithIdentifier:(nullable NSString *)identifier message:(nullable id<NSCoding>)message {
    typedef void (^MessageListenerBlock)(id messageObject);
    
    MessageListenerBlock listenerBlock = [self listenerBlockForIdentifier:identifier];
    
    if (listenerBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            listenerBlock(message);
        });
    }
}


#pragma mark - Public Interface Methods

- (void)passMessageObject:(nullable id <NSCoding>)messageObject identifier:(nullable NSString *)identifier {
    if ([Messenger writeMessageObject:messageObject forIdentifier:identifier]) {
        [self sendNotificationForMessageWithIdentifier:identifier];
    }
}

- (nullable id)messageWithIdentifier:(nullable NSString *)identifier {
    id messageObject = [Messenger messageObjectForIdentifier:identifier];
    return messageObject;
}

- (void)listenForMessageWithIdentifier:(nullable NSString *)identifier
                              listener:(nullable void (^)(__nullable id messageObject))listener {
    if (identifier != nil) {
        [listenerBlocks setValue:listener forKey:identifier];
        [self registerForNotificationsWithIdentifier:identifier];
    }
}

- (void)stopListeningForMessageWithIdentifier:(nullable NSString *)identifier {
    if (identifier != nil) {
        [listenerBlocks setValue:nil forKey:identifier];
        [self unregisterForNotificationsWithIdentifier:identifier];
    }
}

@end

NS_ASSUME_NONNULL_END
