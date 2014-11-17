//
//  PPShip.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 06/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"
#import "Masks.h"

@interface PPShip ()

@property SKSpriteNode * shipNode;
@property SKSpriteNode * rocketNode;

@property NSInteger height;
@property NSInteger width;

@property CGFloat lastRocketFireTimestamp;

@end

@implementation PPShip

-(void)updateLocationByX:(CGFloat)x byY:(CGFloat)y
{
    CGPoint pos = self.shipNode.position;
    self.shipNode.position = CGPointMake(pos.x + x, pos.y + y);
}

-(id)initWithImageNamed:(NSString *)shipImageName withRocketImageNamed:(NSString *)rocketImageName
{
    self = [super init];
    if (self != nil) {
        self.shipNode = [SKSpriteNode spriteNodeWithImageNamed:shipImageName];
        self.rocketNode = [SKSpriteNode spriteNodeWithImageNamed:rocketImageName];

        self.shipNode.scale = 0.5;

        self.rocketNode.scale = 0.2;

        self.shipNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.shipNode.texture
                                                              size:self.shipNode.size];
        self.rocketNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.rocketNode.texture
                                                                size:self.rocketNode.size];
        self.shipNode.physicsBody.affectedByGravity = NO;
        self.rocketNode.physicsBody.affectedByGravity = NO;

        self.shipNode.physicsBody.allowsRotation = NO;
        self.rocketNode.physicsBody.allowsRotation = NO;

        self.rocketNode.physicsBody.collisionBitMask = PP_THROUGH_EDGE_BIT_MASK;

        self.width = self.shipNode.size.width;
        self.height = self.shipNode.size.height;

        self.isFiring = NO;
        self.lastRocketFireTimestamp = 0;
        self.rocketDirection = 0;
        [self initNextDirection];

        self.health = PP_MAX_HEALTH;
        self.lives = PP_LIVES_COUNT;
    }
    return self;
}

-(void)setPositionWithSceneWidth:(int)width withHeight:(int)height
{
    self.shipNode.position = [self getInitialShipPositionWithSceneWidth:width
                                                        withSceneHeight:height];
}

-(void)resetHorizontalMovement { self.nextDirectionX = 0; }
-(void)resetVerticalMovement   { self.nextDirectionY = 0; }

-(CGFloat)getX { return self.shipNode.position.x; }
-(CGFloat)getY { return self.shipNode.position.y; }

-(void)initNextDirection
{
    [self resetHorizontalMovement];
    [self resetVerticalMovement];
}

-(void)move
{
    [self updateLocationByX: self.nextDirectionX byY: self.nextDirectionY];
}

-(void)startFiring { self.isFiring = YES; }
-(void)stopFiring  { self.isFiring = NO;  }

-(void)prepareToMove:(enum PP_Move)direction
{
    switch (direction) {
        case PP_MOVE_UP:
            self.nextDirectionY += PP_MOVE_INCR;
            break;
        case PP_MOVE_DOWN:
            self.nextDirectionY -= PP_MOVE_INCR;
            break;
        case PP_MOVE_LEFT:
            self.nextDirectionX -= PP_MOVE_INCR;
            break;
        case PP_MOVE_RIGHT:
            self.nextDirectionX += PP_MOVE_INCR;
            break;
    }
}

-(void)prepareToMoveUp    { [self prepareToMove:PP_MOVE_UP]; }
-(void)prepareToMoveDown  { [self prepareToMove:PP_MOVE_DOWN]; }
-(void)prepareToMoveLeft  { [self prepareToMove:PP_MOVE_LEFT]; }
-(void)prepareToMoveRight { [self prepareToMove:PP_MOVE_RIGHT]; }

// should be dynamic
#define MAX_ROCKET_DELAY 0.2

-(SKSpriteNode *)fireRocket
{

    if (!self.isFiring) { return nil; }

    CGFloat n = [[NSDate date] timeIntervalSinceReferenceDate];

    if (n < (CGFloat)self.lastRocketFireTimestamp + MAX_ROCKET_DELAY) {
        return nil;
    }
    self.lastRocketFireTimestamp = n;

    SKSpriteNode * rocket = [self.rocketNode copy];

    rocket.position = [self getInitialRocketPosition];

    [rocket runAction: [SKAction moveByX:PP_ROCKET_OFFSET*self.rocketDirection
                                       y:0
                                duration:PP_ROCKET_DURATION]];

    return rocket;
}

-(void)updateHealth:(int)health
{

    if ([self isDestroyed]) {
        return;
    }

    self.health += health;

    if (self.health <= 0) {
        self.lives--;
        if (self.lives > 0) {
            self.health = PP_MAX_HEALTH;
        }
    }
}

-(void)receiveRocket
{
    [self updateHealth: -10];
}

-(BOOL)isDestroyed
{
    return self.lives <= 0;
}

// override these in children classes

-(CGPoint)getInitialRocketPosition
{
    return CGPointMake(self.x + self.width/2, self.y);
}

-(CGPoint)getInitialShipPositionWithSceneWidth:(int)width withSceneHeight:(int)height
{
    return CGPointMake(width/2, height/2);
}

@end
