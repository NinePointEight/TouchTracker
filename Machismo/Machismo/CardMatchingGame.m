//
//  CardMatchingGame.m
//  Machismo
//
//  Created by 成鑫 on 15/4/20.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "CardMatchingGame.h"

#define __DEBUG__ 1
@interface CardMatchingGame ()

@property (nonatomic)NSUInteger matchCount;
@property (nonatomic, readwrite)NSInteger score;
@property (nonatomic, strong)NSMutableArray *cards; // of Card
@property (nonatomic, strong)NSMutableArray *chosenCards; // 待匹配的卡牌

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define COST_TO_CHOSE 1
#define THREE_CARDS_MATCH 20
- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (__DEBUG__)
            NSLog(@"当前卡牌还没有被配对");
        if (card.isChosen) {
            if (__DEBUG__)
                NSLog(@"当前卡牌已被选中");
            [self.chosenCards removeObject:card];
            card.chosen = NO;
        } else {
            if ([self.chosenCards count] < self.matchCount -1) {
                [self.chosenCards addObject:card];
            } else {
                int matchScore;
                matchScore = [card match:self.chosenCards];
                [self.chosenCards addObject:card];
                NSArray *copyChosenCards = [self.chosenCards mutableCopy];
                
                if (matchScore) {
                    switch (matchScore) {
                        case 1:
                            matchScore = matchScore * MATCH_BONUS;
                            break;
                        case 3:
                            matchScore = matchScore * THREE_CARDS_MATCH;
                            break;
                        case 4:
                            matchScore = matchScore * MATCH_BONUS;
                            break;
                        case 5:
                            matchScore = matchScore * MATCH_BONUS;
                            break;
                        case 8:
                            matchScore = matchScore * MATCH_BONUS;
                            break;
                        case 12:
                            matchScore = matchScore * THREE_CARDS_MATCH * 5;
                            break;
                        default:
                            if (__DEBUG__)
                                NSLog(@"得%d分", matchScore * 2);
                            break;
                    }
                    self.score += matchScore;
                    for (Card *otherCard in self.chosenCards)
                        otherCard.matched = YES;
                    self.gameInfo = [NSString stringWithFormat:@"%@ 匹配得分 +%d!",[copyChosenCards componentsJoinedByString:@","], matchScore];
                    [self.chosenCards removeAllObjects];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in self.chosenCards)
                        otherCard.chosen = NO;
                    self.gameInfo = [NSString stringWithFormat:@"%@ 未匹配 -%d!",[copyChosenCards componentsJoinedByString:@","], MISMATCH_PENALTY];
                    [self.chosenCards removeAllObjects];
                    [self.chosenCards addObject:card];
                }
            }
            self.score -= COST_TO_CHOSE;
            card.chosen = YES;
            if (__DEBUG__)
                NSLog(@"当前卡牌已被选中");
        }
    }
}



- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)value
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            self.score = 0;
        }
        self.matchCount = value;
        if (__DEBUG__)
            NSLog(@"CardMatchGame牌堆成功初始化，使用卡牌数量:%lu",(unsigned long)count);
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? [self.cards objectAtIndex:index] : nil;
}
@end
