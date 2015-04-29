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

@property (nonatomic, readwrite)NSInteger score;
@property (nonatomic, readwrite)NSString *scoreInfo;
@property (nonatomic, strong)NSMutableArray *cards; // of Card
@property (nonatomic, strong)NSMutableArray *chosenCards;
@property (nonatomic, readwrite)NSUInteger matchCount;

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

- (void)flipOverChosenCards:(BOOL)shouldFlip
{
    for (Card *card in self.chosenCards) {
        card.chosen = shouldFlip;
        card.matched = shouldFlip;
    }
    [self.chosenCards removeAllObjects];
}

#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define COST_TO_CHOSE 1
#define TWO_MATCHED 2


- (NSInteger)calculateScore:(NSInteger)matchScore
{
    switch (matchScore) {
        case 1:
            self.scoreInfo =
            [NSString stringWithFormat:@"两张花色相同，得%d分",matchScore * TWO_MATCHED];
            return matchScore * TWO_MATCHED;
            break;
        case 3:
            self.scoreInfo =
            [NSString stringWithFormat:@"三张花色相同，得%d分",matchScore * TWO_MATCHED];
            return matchScore * MATCH_BONUS;
            break;
        case 4:
            self.scoreInfo =
            [NSString stringWithFormat:@"两张点数相同，得%d分",matchScore * MATCH_BONUS];
            return matchScore * MATCH_BONUS;
            break;
        case 5:
            self.scoreInfo =
            [NSString stringWithFormat:@"两张点数相同，两张花色相同，得%d分",matchScore * MATCH_BONUS];
            return matchScore * MATCH_BONUS;
            break;
        case 12:
            self.scoreInfo =
            [NSString stringWithFormat:@"三张点数相同，得%d分",matchScore * MATCH_BONUS * 5];
            return matchScore * MATCH_BONUS * 5;
        default:
            self.scoreInfo =
            [NSString stringWithFormat:@"得%d分",matchScore * MATCH_BONUS/2];
            return matchScore * MATCH_BONUS / 2;
            break;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
         self.scoreInfo = [NSString stringWithFormat:@"选中了%@",[card contents]];
//---------------------------------------------------
if (__DEBUG__)
    NSLog(@"当前卡牌还没有被配对");
//---------------------------------------------------
        if (card.isChosen) {

//---------------------------------------------------
if (__DEBUG__)
    NSLog(@"再次被选中，翻面");
//---------------------------------------------------
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        } else {
            if ([self.chosenCards count] < self.matchCount - 1) {
                [self.chosenCards addObject:card];
//---------------------------------------------------
if (__DEBUG__)
    NSLog(@"待匹配数组未满，卡牌加入之");
//---------------------------------------------------
            } else {
//---------------------------------------------------
if (__DEBUG__)
    NSLog(@"开始匹配");
//---------------------------------------------------
                NSInteger matchScore = [card match:self.chosenCards];
                if (matchScore) {
//---------------------------------------------------
if (__DEBUG__)
    NSLog(@"匹配成功，得分");
//---------------------------------------------------
                    [self flipOverChosenCards:YES];
                    card.matched = YES;
                    self.score += [self calculateScore:matchScore];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    self.scoreInfo = [NSString stringWithFormat:@"匹配失败，扣%d分", MISMATCH_PENALTY];
                    [self flipOverChosenCards:NO];
                    [self.chosenCards addObject:card];
                }
            }
        }
        card.chosen = YES;
        self.score -= COST_TO_CHOSE;
    }
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                   withMatchCount:(NSUInteger)matchCount
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
            self.score -= COST_TO_CHOSE;
        }
        self.score = 0;
        self.matchCount = matchCount;
        if (__DEBUG__)
            NSLog(@"CardMatchGame牌堆成功初始化，使用卡牌数量:%lu,匹配模式:%d张",(unsigned long)count, self.matchCount);
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? [self.cards objectAtIndex:index] : nil;
}
@end
