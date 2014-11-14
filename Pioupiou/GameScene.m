//
//  GameScene.m
//  Pioupiou
//
//  Created by Baptiste Fontaine on 06/11/2014.
//  Copyright (c) 2014 Baptiste Fontaine. All rights reserved.
//

#import "GameScene.h"

#define SCORES_FONT_SIZE 80

@interface GameScene ()

@property PPPlayer * playerShip;
@property PPEnemy * enemyShip;

@property SKLabelNode * playerHealthLabel;
@property SKLabelNode * enemyHealthLabel;
@property SKLabelNode * playerLivesLabel;
@property SKLabelNode * enemyLivesLabel;


@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {

    CGFloat width = self.size.width,
           height = self.size.height;

    // background image
    SKTexture * bg = [SKTexture textureWithImage:[NSImage imageNamed:@"GameBackground"]];
    SKSpriteNode * playground = [SKSpriteNode spriteNodeWithTexture:bg size:self.size];
    playground.position = CGPointMake(width/2, height/2);
    [playground setSize:self.size];

    [self addChild:playground];

    // ships
    self.playerShip = [[PPPlayer alloc] init];
    self.enemyShip = [[PPEnemy alloc] init];

    [self.playerShip setPositionWithSceneWidth:width withHeight:height];
    [self.enemyShip setPositionWithSceneWidth:width withHeight:height];

    self.physicsWorld.contactDelegate = self;

    // limits
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

    [self addChild:self.playerShip.shipNode];
    [self addChild:self.enemyShip.shipNode];

    CGFloat leftX  = SCORES_FONT_SIZE,
            rightX = self.size.width - SCORES_FONT_SIZE,
            firstLineY = self.size.height - SCORES_FONT_SIZE,
            secondLineY = firstLineY - SCORES_FONT_SIZE;

    // player
    self.playerHealthLabel = [self addLabelNodeWithX:leftX  withY:firstLineY];
    self.playerLivesLabel =  [self addLabelNodeWithX:leftX  withY:secondLineY];
    self.enemyHealthLabel =  [self addLabelNodeWithX:rightX withY:firstLineY];
    self.enemyLivesLabel =   [self addLabelNodeWithX:rightX withY:secondLineY];
}

-(SKLabelNode *)addLabelNodeWithX:(CGFloat)x withY:(CGFloat)y
{
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"helvetica"];
    [label setFontColor: [NSColor blackColor]];
    [label setFontSize:SCORES_FONT_SIZE];
    [label setPosition:CGPointMake(x, y)];
    [self addChild:label];
    return label;
}

-(NSString *)repeatSymbol:(NSString *)symbol times:(NSInteger)times
{
    if (times <= 0) {
        return @"";
    }
    return [@"" stringByPaddingToLength:(times * [symbol length])
                             withString:symbol
                        startingAtIndex:0];
}

-(NSString *)livesAsText:(PPShip *)ship
{
    return [self repeatSymbol:@"❤️" times:ship.lives];
}

-(NSString *)healthAsText:(PPShip *)ship
{
    return [NSString stringWithFormat:@"%ld", (long)ship.health];
}

-(void)updateHealthAndLivesLabels
{
    self.playerHealthLabel.text = [self healthAsText:self.playerShip];
    self.enemyHealthLabel.text = [self healthAsText:self.enemyShip];
    self.playerLivesLabel.text = [self livesAsText:self.playerShip];
    self.enemyLivesLabel.text = [self livesAsText:self.enemyShip];
}

-(void)handleKeyEvent:(NSEvent *)theEvent withKeyDown:(BOOL)keyDown {
    NSString * keys = [theEvent charactersIgnoringModifiers];
    NSUInteger length = [keys length];

    if (length == 0 || [theEvent isARepeat]) { return; }

    unichar keyChar = [keys characterAtIndex:0];

    switch (keyChar) {
        case NSUpArrowFunctionKey:
            if (keyDown) {
                [self.playerShip prepareToMoveUp];
            } else {
                [self.playerShip resetVerticalMovement];
            }
            break;
        case NSDownArrowFunctionKey:
            if (keyDown) {
                [self.playerShip prepareToMoveDown];
            } else {
                [self.playerShip resetVerticalMovement];
            }
            break;
        case NSLeftArrowFunctionKey:
            if (keyDown) {
                [self.playerShip prepareToMoveLeft];
            } else {
                [self.playerShip resetHorizontalMovement];
            }
            break;
        case NSRightArrowFunctionKey:
            if (keyDown) {
                [self.playerShip prepareToMoveRight];
            } else {
                [self.playerShip resetHorizontalMovement];
            }
            break;
        case ' ':
            if (keyDown) {
                [self.playerShip startFiring];
            } else {
                [self.playerShip stopFiring];
            }
            break;
    }
}

-(void)keyDown:(NSEvent *)theEvent {
    [self handleKeyEvent:theEvent withKeyDown:true];
}

-(void)keyUp:(NSEvent *)theEvent {
    [self handleKeyEvent:theEvent withKeyDown:false];
}

- (void)update:(NSTimeInterval)currentTime
{
    // moves
    [self.playerShip move];
    [self.enemyShip move];

    // rockets
    SKSpriteNode * pRocket = [self.playerShip fireRocket],
                 * eRocket = [self.enemyShip fireRocket];
    if (pRocket != nil) {
        [self addChild:pRocket];
    }
    if (eRocket != nil) {
        [self addChild:eRocket];
    }
}

-(void)didSimulatePhysics
{
    for (SKNode * node in self.children) {
        // remove hidden nodes
        // TODO don't remove ships (only rockets)
        if (node.position.y < 0 ||
            node.position.y > self.size.height ||
            node.position.x < 0 ||
            node.position.x > self.size.width) {
            [node removeFromParent];
        }
    }
}

-(void)didFinishUpdate
{
    // labels
    [self updateHealthAndLivesLabels];

    // move the enemy
    [self.enemyShip update];
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    int bitA = contact.bodyA.contactTestBitMask;
    int bitB = contact.bodyB.contactTestBitMask;

    if (bitA == bitB) { return; }

    // same side
    if ((bitA & PP_PLAYER_BIT_MASK) == (bitB & PP_PLAYER_BIT_MASK)) {
        return;
    }

    // remove rockets

    if (bitA & PP_ROCKET_BIT_MASK) {
        [contact.bodyA.node removeFromParent];
    }

    if (bitB & PP_ROCKET_BIT_MASK) {
        [contact.bodyB.node removeFromParent];
    }

    // destroy ships

    if ((bitA == PP_ENEMY_SHIP_BIT_MASK) || (bitB == PP_ENEMY_SHIP_BIT_MASK)) {
        [self.enemyShip receiveRocket];
    }

    if ((bitA == PP_PLAYER_SHIP_BIT_MASK) || (bitB == PP_PLAYER_SHIP_BIT_MASK)) {
        [self.playerShip receiveRocket];
    }
}

@end
