//
//  BNRImageStore.m
//  Homepwner
//
//  Created by 梁世平 on 16/3/19.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "BNRImageStore.h"
#import <UIKit/UIKit.h>

@interface BNRImageStore()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton"
                                   reason:@"Use +[BNRImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forkey:(NSString *)key
{
    self.dictionary[key] = image;
    NSString *imagePath = [self imagePathForKey:key];
    NSData *pngData = UIImagePNGRepresentation(image);
    //NSData *jpegData = UIImageJPEGRepresentation(image, 0.5);
    [pngData writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    //return self.dictionary[key];
    
    UIImage *result = self.dictionary[key];
    if(!result)
    {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        if(result){
            self.dictionary[key] = result;
        }
        else{
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docmentDirectory = [documentDirectories firstObject];
    return [docmentDirectory stringByAppendingPathComponent:key];
}


@end
