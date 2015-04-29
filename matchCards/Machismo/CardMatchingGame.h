//
//  CardMatchingGame.h
//  Machismo
//
//  Created by 成鑫 on 15/4/20.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// 指定初始化方法
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deckwith
                   withMatchCount:(NSUInteger)matchCount;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly)NSInteger score;
@property (nonatomic, readonly)NSString *scoreInfo;

@end
