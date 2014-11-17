//
//  GameSupport.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 17/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSupport : NSObject

+(void)saveBestScore:(NSInteger)bestScore;
+(NSInteger)retrieveBestScore;

@end
