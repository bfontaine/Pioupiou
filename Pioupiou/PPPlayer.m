//
//  PPPlayer.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPPlayer.h"

@implementation PPPlayer

-(id)init
{
    self = [super initWithImageNamed:@"PlayerShip"
                withRocketImageNamed:@"PlayerRocket"];

    if (self != nil) {
        self.shipNode.physicsBody.contactTestBitMask = PP_PLAYER_SHIP_BIT_MASK;
        self.rocketNode.physicsBody.contactTestBitMask = PP_PLAYER_ROCKET_BIT_MASK;
        self.rocketDirection = 1;
    }

    return self;
}

-(CGPoint)getInitialRocketPosition
{
    return CGPointMake(self.x + self.width/2 + self.rocketNode.size.width/2, self.y);
}

-(CGPoint)getInitialShipPositionWithSceneWidth:(int)width withSceneHeight:(int)height
{
    return CGPointMake(width/4, height/2);
}

@end