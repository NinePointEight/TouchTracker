//
//  Card.h
//  Machismo
//
//  Created by 成鑫 on 15/4/18.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
