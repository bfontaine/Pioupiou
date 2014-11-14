//
//  PPShip.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 06/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define PP_SHIP_BIT_MASK 2
#define PP_ROCKET_BIT_MASK 1

#define PP_ROCKET_OFFSET 10000
#define PP_ROCKET_DURATION 15

#define PP_MAX_HEALTH 100
#define PP_LIVES_COUNT 2

#define PP_MOVE_INCR 5

enum PP_Move {
    PP_MOVE_UP,
    PP_MOVE_DOWN,
    PP_MOVE_LEFT,
    PP_MOVE_RIGHT
};

@interface PPShip : NSObject

@property (readonly) SKSpriteNode * shipNode;
@property (readonly) SKSpriteNode * rocketNode;

@property NSInteger rocketDirection;

@property (readonly, getter=getX) CGFloat x;
@property (readonly, getter=getY) CGFloat y;

@property (readonly) NSInteger height;
@property (readonly) NSInteger width;

@property BOOL isFiring;

@property NSInteger health;
@property NSInteger lives;

-(id)initWithImageNamed:(NSString *)imgName withRocketImageNamed:(NSString *)name;

-(void)setPositionWithSceneWidth:(int)width withHeight:(int)height;

-(void)prepareToMoveUp;
-(void)prepareToMoveDown;
-(void)prepareToMoveLeft;
-(void)prepareToMoveRight;

-(void)resetHorizontalMovement;
-(void)resetVerticalMovement;

-(void)updateLocationByX:(CGFloat)x byY:(CGFloat)y;

-(void)move;

-(SKSpriteNode *)fireRocket;
-(void)receiveRocket;

-(CGPoint)getInitialRocketPosition;
-(CGPoint)getInitialShipPositionWithSceneWidth:(int)width withSceneHeight:(int)height;

@end
