//
//  PPEnemy.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPEnemy.h"
#import "Masks.h"

@implementation PPEnemy

-(id)init
{
    self = [super initWithImageNamed:@"EnemyShip"
                withRocketImageNamed:@"EnemyRocket"];

    if (self != nil) {
        self.shipNode.physicsBody.categoryBitMask = PP_ENEMY_SHIP_BIT_MASK;
        self.rocketNode.physicsBody.categoryBitMask = PP_ENEMY_ROCKET_BIT_MASK;

        self.shipNode.physicsBody.contactTestBitMask = PP_PLAYER_ROCKET_BIT_MASK;
        self.rocketNode.physicsBody.contactTestBitMask = PP_PLAYER_SHIP_BIT_MASK;

        self.rocketDirection = -1;
    }

    return self;
}

-(CGPoint)getInitialRocketPosition
{
    return CGPointMake(self.x - self.width/2 - self.rocketNode.size.width/2,
                       self.y);
}

-(CGPoint)getInitialShipPositionWithSceneWidth:(int)width withSceneHeight:(int)height
{
    return CGPointMake(width/4*3, height/2);
}

-(BOOL)isMovingUp { return self.nextDirectionY > 0; }
-(BOOL)isMovingDown { return self.nextDirectionY < 0; }

-(void)update
{
    int rand = arc4random_uniform(100);

    // start/stop firing

    if (self.isFiring) {
        if (rand < 85) {
            [self stopFiring];
        }
    } else if (rand < 5) {
        [self startFiring];
    }

    // move

    if ([self isMovingDown] || [self isMovingUp]) {
        if (rand < 15) {
            [self resetVerticalMovement];
        }
    } else {
        if (rand < 50) {
            [self prepareToMoveUp];
        } else {
            [self prepareToMoveDown];
        }
    }
}

@end