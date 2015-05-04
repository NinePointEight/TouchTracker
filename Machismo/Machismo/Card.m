//
//  Card.m
//  Machismo
//
//  Created by 成鑫 on 15/4/18.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "Card.h"

@interface Card ()

@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score += 1;
        }
    }
    
    return  score;
}

- (NSString *)description
{
    return self.contents;
}

@end
