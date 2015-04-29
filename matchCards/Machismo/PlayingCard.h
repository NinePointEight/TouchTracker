//
//  PlayingCard.h
//  Machismo
//
//  Created by 成鑫 on 15/4/19.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong,nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
