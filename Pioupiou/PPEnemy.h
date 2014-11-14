//
//  PPEnemy.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"

#define PP_ENEMY_BIT_MASK 8

#define PP_ENEMY_SHIP_BIT_MASK (PP_SHIP_BIT_MASK|PP_ENEMY_BIT_MASK)
#define PP_ENEMY_ROCKET_BIT_MASK (PP_ROCKET_BIT_MASK|PP_ENEMY_BIT_MASK)

@interface PPEnemy : PPShip

-(void)update;

@end
