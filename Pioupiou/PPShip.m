//
//  PPShip.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 06/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"

@interface PPShip ()

@property SKSpriteNode * shipNode;
@property SKSpriteNode * rocketNode;

@property NSInteger height;
@property NSInteger width;

@property CGFloat nextDirectionX;
@property CGFloat nextDirectionY;

@property CGFloat lastRocketFireTimestamp;

@end

@implementation PPShip

-(void)updateLocationByX:(CGFloat)x byY:(CGFloat)y {
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
        self.rocketNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.rocketNode.texture
                                                                size:self.rocketNode.size];
        self.rocketNode.physicsBody.affectedByGravity = NO;

        self.width = self.shipNode.size.width;
        self.height = self.shipNode.size.height;

        self.isFiring = NO;
        self.lastRocketFireTimestamp = 0;
        self.rocketDirection = 0;
        [self initNextDirection];

        self.health = PP_MAX_HEALTH;
        self.lives = PP_LIVES_COUNT;

        self.shipNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.shipNode.texture
                                                              size:self.shipNode.size];
        self.shipNode.physicsBody.affectedByGravity = NO;

//        self.shipNode.physicsBody.categoryBitMask = PP_SHIP_BIT_MASK;
//        self.shipNode.physicsBody.collisionBitMask = PP_ROCKET_BIT_MASK;
//
//        self.shipNode.physicsBody.categoryBitMask = PP_ROCKET_BIT_MASK;
//        self.shipNode.physicsBody.collisionBitMask = PP_SHIP_BIT_MASK;
    }
    return self;
}

-(void)setPositionWithSceneWidth:(int)width withHeight:(int)height
{
    self.shipNode.position = [self getInitialShipPositionWithSceneWidth:width
                                                        withSceneHeight:height];
}

-(void)resetHorizontalMovement
{
    self.nextDirectionX = 0;
}

-(void)resetVerticalMovement
{
    self.nextDirectionY = 0;
}

-(CGPoint)position
{
    return self.shipNode.position;
}

-(CGFloat)getX
{
    return [self position].x;
}

-(CGFloat)getY
{
    return [self position].y;
}

-(void)initNextDirection
{
    [self resetHorizontalMovement];
    [self resetVerticalMovement];
}

-(void)move
{
    [self updateLocationByX: self.nextDirectionX byY: self.nextDirectionY];
}

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

-(void)prepareToMoveUp   { [self prepareToMove:PP_MOVE_UP]; }
-(void)prepareToMoveDown { [self prepareToMove:PP_MOVE_DOWN]; }
-(void)prepareToMoveLeft { [self prepareToMove:PP_MOVE_LEFT]; }
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

    rocket.position = CGPointMake(self.x + self.width/2 + rocket.size.width/2,
                                  self.y);

    [rocket runAction: [SKAction moveByX:PP_ROCKET_OFFSET*self.rocketDirection
                                       y:0
                                duration:PP_ROCKET_DURATION]];

    return rocket;
}

-(void)updateHealth:(int)health
{
    self.health += health;

    // TODO check when lives <= 0
    if (self.health <= 0) {
        self.lives -= 1;
        self.health = PP_MAX_HEALTH;
    }
}

-(void)receiveRocket
{
    [self updateHealth: -10];
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
