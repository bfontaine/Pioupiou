//
//  PPEnemy.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"

/**
 *  Bit mask of something from the enemy
 */
#define PP_ENEMY_BIT_MASK 8

/**
 *  Bit mask of the enemy’s ship
 */
#define PP_ENEMY_SHIP_BIT_MASK (PP_SHIP_BIT_MASK|PP_ENEMY_BIT_MASK)

/**
 *  Bit mask of an enemy’s rocket
 */
#define PP_ENEMY_ROCKET_BIT_MASK (PP_ROCKET_BIT_MASK|PP_ENEMY_BIT_MASK)

@interface PPEnemy : PPShip

/**
 *  Automatically update the enemy’s movements and firing mode.
 */
-(void)update;

@end
