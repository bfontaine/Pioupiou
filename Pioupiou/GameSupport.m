//
//  GameSupport.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 17/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "GameSupport.h"

@implementation GameSupport

+(NSString *)scoreFilePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSURL *appsDir = [manager URLForDirectory:NSApplicationSupportDirectory
                                     inDomain:NSUserDomainMask
                            appropriateForURL:nil
                                       create:YES
                                        error:nil];

    NSURL * appDir = [appsDir URLByAppendingPathComponent:@"Pioupiou" isDirectory:YES];
    NSString * appDirPath = [appDir absoluteString];
    NSFileManager * fs = [NSFileManager defaultManager];

    if (![fs fileExistsAtPath:appDirPath]) {
        [fs createDirectoryAtPath:appDirPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }

    NSString * path = [[appDir URLByAppendingPathComponent:@"scores.txt"] absoluteString];

    if (![fs fileExistsAtPath:path]) {
        [fs createFileAtPath:path contents:nil attributes:nil];
    }

    return path;
}

+(void)saveBestScore:(NSInteger)bestScore
{
    NSString * text = [NSString stringWithFormat:@"%ld", (long)bestScore];
    NSString * path = [GameSupport scoreFilePath];

    [text writeToFile:path
           atomically:YES
             encoding:NSUTF8StringEncoding
                error:nil];
}

+(NSInteger)retrieveBestScore
{
    NSError * error;
    NSString * text = [NSString stringWithContentsOfFile:[GameSupport scoreFilePath]
                                                   encoding:NSUTF8StringEncoding
                                                  error:&error];

    if (text == nil) {
        NSLog(NSLocalizedString(@"Error: %@", nil), [error localizedDescription]);
        return 0;
    } else {
        return [text integerValue];
    }
}

@end
