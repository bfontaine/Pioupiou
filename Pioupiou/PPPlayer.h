//
//  PPPlayer.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"

/**
 *  Bit mask of something from the player
 */
#define PP_PLAYER_BIT_MASK 4

/**
 *  Bit mask of the player’s ship
 */
#define PP_PLAYER_SHIP_BIT_MASK (PP_SHIP_BIT_MASK|PP_PLAYER_BIT_MASK)

/**
 *  Bit mask of a player’s rocket
 */
#define PP_PLAYER_ROCKET_BIT_MASK (PP_ROCKET_BIT_MASK|PP_PLAYER_BIT_MASK)

@interface PPPlayer : PPShip

@end
