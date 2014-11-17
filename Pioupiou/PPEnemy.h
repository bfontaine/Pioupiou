//
//  PPEnemy.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 13/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "PPShip.h"


@interface PPEnemy : PPShip

/**
 *  Automatically update the enemy’s movements and firing mode, given the
 *  player’s ship position.
 *
 *  @param position the player’s ship position
 */
-(void)updateWithPlayerShipPosition:(CGPoint)position;

@end
