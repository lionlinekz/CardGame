//
//  MatchGame.m
//  CardGame
//
//  Created by 黄 嘉恒 on 1/31/13.
//  Copyright (c) 2013 黄 嘉恒. All rights reserved.
//

#import "MatchGame.h"

#define FLIP_COST 1
#define UNMATCH_SCORE 2
#define MATCH_MULTIPLY 4

@interface MatchGame()
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,readwrite) NSUInteger flipCount;
@property (nonatomic,strong,readwrite)NSString *result;
@property (nonatomic,strong,readwrite)NSMutableArray *cards;
@end

@implementation MatchGame

-(NSMutableArray *)cards{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
    self = [super init];
    if (self && count <= [deck.cards count]) {
        for (int i = 0; i < count; i++) {
            self.cards[i] = [deck drawRandomCard];
        }
        self.result = @"Game started";
        self.flipCount = 0;
    }
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index]:nil;
}

-(void)flipCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    card.FaceUp = !card.isFaceUp;
    if (!card.isUnplayable && card.isFaceUp) {
        self.flipCount ++;
        self.score -= FLIP_COST;
        NSString *result = [[NSString alloc] initWithFormat:@"Flipped up %@",card.contents];
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable && otherCard != card) {
                NSInteger matchScore = [card match:@[otherCard]];
                if (matchScore) {
                    self.score += matchScore * MATCH_MULTIPLY;
                    card.Unplayable = YES;
                    otherCard.Unplayable = YES;
                    result = [[NSString alloc] initWithFormat:@"Matched %@ & %@ for %d points",otherCard.contents,card.contents,matchScore * MATCH_MULTIPLY];
                } else {
                    self.score -= UNMATCH_SCORE;
                    card.FaceUp = NO;
                    otherCard.FaceUp = NO;
                    result = [[NSString alloc] initWithFormat:@"%@ and %@ don’t match! %d point penalty!",otherCard.contents,card.contents,UNMATCH_SCORE];
                }
                break;
            }
        }
        self.result = result;
    }
}


@end