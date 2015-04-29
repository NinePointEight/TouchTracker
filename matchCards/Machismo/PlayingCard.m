//
//  PlayingCard.m
//  Machismo
//
//  Created by 成鑫 on 15/4/19.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] != 0) {
        if ([otherCards count] == 1) {
            PlayingCard *otherCard = [otherCards firstObject];
            if ([self.suit isEqualToString: otherCard.suit]) {
                score = 1;
            } else if (self.rank == otherCard.rank) {
                score = 4;
            }
        } else {
            for (PlayingCard *otherCard in otherCards)
                score += [self match:@[otherCard]];
            NSUInteger currentIndex = 0;
            NSUInteger unmatchedCards = [otherCards count] - 1;
            
            if (currentIndex < unmatchedCards) {
                PlayingCard *card = [otherCards objectAtIndex:currentIndex++];
                NSRange range = NSMakeRange(currentIndex, unmatchedCards);
                score += [card match:[otherCards subarrayWithRange:range]];
            }
        }
    }
    return score;
}

+ (NSArray *)validSuits
{
    return @[@"♠",@"♣",@"♥",@"♦"];
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
       _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
