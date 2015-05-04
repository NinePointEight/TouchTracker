//
//  PlayingCardDeck.m
//  Machismo
//
//  Created by 成鑫 on 15/4/19.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#define __DEBUG__ 1

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
                if (__DEBUG__)
                    NSLog(@"生成卡牌:%@", [card contents]);
            }
        }
        if (__DEBUG__)
            NSLog(@"PlayingCard成功初始化,卡牌数量%ld",(long)[self countOfCards]);
    }
    return self;
}

@end
