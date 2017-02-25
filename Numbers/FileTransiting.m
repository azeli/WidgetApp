//
//  FileTransiting.m
//  Numbers
//
//  Created by Edward Snowden on 21.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileTransiting.h"

@interface FileTransiting ()

@property (nonatomic, copy) NSString *applicationGroupIdentifier;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong, readwrite) NSFileManager *fileManager;

@end

@implementation FileTransiting

- (instancetype)init {
    return [self initWithApplicationGroupIdentifier:@"dev.assertion.nonDesignatedInitializer"
                                  optionalDirectory:nil];
}

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory {
    if ((self = [super init])) {
        _applicationGroupIdentifier = [identifier copy];
        _directory = [directory copy];
        _fileManager = [[NSFileManager alloc] init];
    }
    
    return self;
}


#pragma mark - Private File Operation Methods

- (nullable NSString *)messagePassingDirectoryPath {
    NSURL *appGroupContainer = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:self.applicationGroupIdentifier];
    NSString *appGroupContainerPath = [appGroupContainer path];
    NSString *directoryPath = appGroupContainerPath;
    
    if (self.directory != nil) {
        directoryPath = [appGroupContainerPath stringByAppendingPathComponent:self.directory];
    }
    
    [self.fileManager createDirectoryAtPath:directoryPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
    
    return directoryPath;
}

- (nullable NSString *)filePathForIdentifier:(nullable NSString *)identifier {
    if (identifier == nil || identifier.length == 0) {
        return nil;
    }
    
    NSString *directoryPath = [self messagePassingDirectoryPath];
    NSString *fileName = [NSString stringWithFormat:@"%@.archive", identifier];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}


#pragma mark - Public Protocol Methods

- (BOOL)writeMessageObject:(id<NSCoding>)messageObject forIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return NO;
    }
    
    if (messageObject) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:messageObject];
        NSString *filePath = [self filePathForIdentifier:identifier];
        
        if (data == nil || filePath == nil) {
            return NO;
        }
        
        BOOL success = [data writeToFile:filePath atomically:YES];
        
        if (!success) {
            return NO;
        }
    }
    
    return YES;
}

- (id<NSCoding>)messageObjectForIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return nil;
    }
    
    NSString *filePath = [self filePathForIdentifier:identifier];
    
    if (filePath == nil) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data == nil) {
        return nil;
    }
    
    id messageObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return messageObject;
}

@end
