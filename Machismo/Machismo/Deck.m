//
//  Deck.m
//  Machismo
//
//  Created by 成鑫 on 15/4/19.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "Deck.h"
#define __DEBUG__ 1

@interface Deck ()

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation Deck

- (NSInteger)countOfCards
{
    return [self.cards count];
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
        if (__DEBUG__)
            NSLog(@"cards成功初始化,共有%lu张",(unsigned long)[self.cards count]);
    }
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count]) {
        if (__DEBUG__)
            NSLog(@"卡牌被选出，剩余卡牌数量：%d",[self.cards count]);
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
