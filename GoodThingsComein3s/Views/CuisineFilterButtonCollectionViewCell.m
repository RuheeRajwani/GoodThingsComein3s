//
//  CuisineFilterButtonCollectionViewCell.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 8/1/22.
//

#import "CuisineFilterButtonCollectionViewCell.h"

@implementation CuisineFilterButtonCollectionViewCell

- (IBAction)didTapFilterButton:(id)sender {
    [self.delegate didTapFilterButton: self.filterButton];
}

@end
