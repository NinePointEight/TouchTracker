//
//  Deck.h
//  Machismo
//
//  Created by 成鑫 on 15/4/19.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Card.h"
@class Card;
@interface Deck : NSObject

- (NSInteger)countOfCards;
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

-(Card *)drawRandomCard;

@end
