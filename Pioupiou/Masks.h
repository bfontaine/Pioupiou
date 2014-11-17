//
//  Masks.h
//  Pioupiou
//
//  Created by Baptiste Fontaine on 17/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#ifndef Pioupiou_Masks_h
#define Pioupiou_Masks_h

enum PP_Mask {
    PP_PLAYER_SHIP_BIT_MASK   = 0x1 << 0,
    PP_PLAYER_ROCKET_BIT_MASK = 0x1 << 1,

    PP_ENEMY_SHIP_BIT_MASK    = 0x1 << 2,
    PP_ENEMY_ROCKET_BIT_MASK  = 0x1 << 3,

    PP_EDGE_BIT_MASK          = 0x1 << 4,

    // anyone with this as a collisionBitMask will pass through the edges
    PP_THROUGH_EDGE_BIT_MASK  = 0x1 << 5,
};

#endif
