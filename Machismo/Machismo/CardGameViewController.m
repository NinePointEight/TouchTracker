//
//  ViewController.m
//  Machismo
//
//  Created by 成鑫 on 15/4/16.
//  Copyright (c) 2015年 Delic Lib. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "Deck.h"
#import "CardMatchingGame.h"

#define __DEBUG__ 1

@interface ViewController ()

@property (nonatomic, strong) Deck* deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameInfoLabel;


@end

@implementation ViewController

- (IBAction)restartButton:(UIButton *)sender {
    self.game = nil;
    self.scoreLabel.text = @"Score:0";
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc]
                         initWithCardCount:[self.cardButtons count]
                         usingDeck:[self createDeck]
                         withMatchCount:3];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score:%ld", (long)self.game.score];
    self.gameInfoLabel.text = self.game.gameInfo;
    if (__DEBUG__)
        NSLog(@"UI已更新");
}

- (NSString *)titleForCard:(Card *)card
{
    if (card.isChosen)
        return card.contents;
    else
        return @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    if (card.isChosen)
        return [UIImage imageNamed:@"cardfront"];
    else
        return [UIImage imageNamed:@"cardback"];
}

@end
