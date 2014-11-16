//
//  PPShip.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 06/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

/**
 *  Bit mask of a ship
 */
#define PP_SHIP_BIT_MASK 2

/**
 *  Bit mask of a rocket
 */
#define PP_ROCKET_BIT_MASK 1

/**
 *  Offset used for the rocket animation
 */
#define PP_ROCKET_OFFSET 10000

/**
 *  Duration used for the rocket animation
 */
#define PP_ROCKET_DURATION 15

/**
 *  Max health
 */
#define PP_MAX_HEALTH 100

/**
 *  Initial lives number
 */
#define PP_LIVES_COUNT 2

/**
 *  Unit increment for movements
 */
#define PP_MOVE_INCR 5

/**
 *  A move direction
 */
enum PP_Move {
    PP_MOVE_UP,
    PP_MOVE_DOWN,
    PP_MOVE_LEFT,
    PP_MOVE_RIGHT
};

@interface PPShip : NSObject

/**
 *  The node used to represent this ship
 */
@property (readonly) SKSpriteNode * shipNode;

/**
 *  The base node for all rockets fired from this ship
 */
@property (readonly) SKSpriteNode * rocketNode;

/**
 *  Should be `1` if the rocket goes on the right or `-1` if it goes on the
 *  left. This is an integer because it’s use as a multiplier for the target
 *  offset. You could thus use `0` for a rocket which doesn’t move, or `2` for
 *  a rocket which move twice faster than the normal one.
 */
@property NSInteger rocketDirection;

/**
 *  This ship’s X position. This is a proxy to `shipNode.position.x`.
 */
@property (readonly, getter=getX) CGFloat x;

/**
 *  This ship’s Y position. This is a proxy to `shipNode.position.y`.
 */
@property (readonly, getter=getY) CGFloat y;

/**
 *  The next offset on the X axe.
 */
@property CGFloat nextDirectionX;

/**
 *  The next offset on the Y axe.
 */
@property CGFloat nextDirectionY;

/**
 *  This ship’s height.
 */
@property (readonly) NSInteger height;

/**
 *  This ship’s width.
 */
@property (readonly) NSInteger width;

/**
 * A boolean indicating whether the ship is currently firing rockets or not.
 */
@property BOOL isFiring;

@property NSInteger health;
@property NSInteger lives;

/**
 *  Initialize a new ship with an image for the ship itself and for its rockets.
 *
 *  @param imgName ship image
 *  @param name    rocket image
 *
 *  @return the initialized ship.
 */
-(id)initWithImageNamed:(NSString *)imgName withRocketImageNamed:(NSString *)name;

/**
 *  This should be overriden by subclasses. It sets the ship’s position
 *  according to the scene’s width and height.
 *
 *  @param width  the scene’s width
 *  @param height the scene’s height
 */
-(void)setPositionWithSceneWidth:(int)width withHeight:(int)height;

/**
 *  Indicates that the ship should move up on the next frames
 */
-(void)prepareToMoveUp;

/**
 *  Indicates that the ship should move down on the next frames
 */
-(void)prepareToMoveDown;

/**
 *  Indicates that the ship should move left on the next frames
 */
-(void)prepareToMoveLeft;

/**
 *  Indicates the ship should move right on the next frames
 */
-(void)prepareToMoveRight;

/**
 * Cancel any horizontal movement indication
 */
-(void)resetHorizontalMovement;

/**
 *  Cancel any vertical movement indication
 */
-(void)resetVerticalMovement;

/**
 *  Update the ship’s position with a 2D offset
 *
 *  @param x offset on the x axe
 *  @param y offset on the y axe
 */
-(void)updateLocationByX:(CGFloat)x byY:(CGFloat)y;

/**
 *  Apply all given indications and move the ship
 */
-(void)move;

/**
 *  Set the ship in “firing” mode
 */
-(void)startFiring;

/**
 *  Set the ship in “not-firing” mode
 */
-(void)stopFiring;

/**
 *  Return a rocket as fired by this ship
 *
 *  @return the rocket node
 */
-(SKSpriteNode *)fireRocket;

/**
 *  Apply any change on this ship’s health/lives when it gets hit by a rocket.
 */
-(void)receiveRocket;

/**
 *  Test whether this ship has been completely destroyed or not
 *
 *  @return true if it has been completely destroyed
 */
-(BOOL)isDestroyed;

/**
 *  Should be overriden by subclasses to return the initial position of a
 *  rocket fired by this ship.
 *
 *  @return the rocket’s position
 */
-(CGPoint)getInitialRocketPosition;

/**
 *  Should be overriden by subclasses to return the initial position of this
 *  ship from the scene’s width and height.
 *
 *  @param width  scene’s width
 *  @param height scene’s height
 *
 *  @return initial ship’s position
 */
-(CGPoint)getInitialShipPositionWithSceneWidth:(int)width withSceneHeight:(int)height;

@end
