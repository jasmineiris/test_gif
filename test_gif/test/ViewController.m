//
//  ViewController.m
//  test
//
//  Created by Jasmine Farrell on 4/15/16.
//  Copyright © 2016 JIFarrell. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()
@property (weak) IBOutlet UIWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    UIImage *shacho = [UIImage imageNamed:@"image1"];
    UIImage *bucho = [UIImage imageNamed:@"image2"];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path],
                                                                        kUTTypeGIF,
                                                                        2,
                                                                        NULL);
    
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0.97594] forKey:(NSString *)kCGImagePropertyGIFDelayTime]
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    CGImageDestinationAddImage(destination, shacho.CGImage, (CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, bucho.CGImage, (CFDictionaryRef)frameProperties);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    NSLog(@"animated GIF file created at %@", path);
    
    [self getGifFromDirectory];
}

- (void)getGifFromDirectory {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    NSData *gifData = [NSData dataWithContentsOfFile:[fileURL path]];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"Success at %@", [assetURL path] );
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
