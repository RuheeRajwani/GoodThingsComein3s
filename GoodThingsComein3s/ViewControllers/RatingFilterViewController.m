//
//  RatingFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "RatingFilterViewController.h"

@interface RatingFilterViewController ()

@property (nonatomic) NSMutableArray *selectedRatingFilters;
@property (weak, nonatomic) IBOutlet UIButton *oneStarButton;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *twoStarButton;
@property (weak, nonatomic) IBOutlet UIButton *threeStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fourStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveStarButton;

@end

@implementation RatingFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRatingFilters = [self.previouslySelectedRatingFilters mutableCopy];
    [self setButtons];
}

- (IBAction)ratingsFilterViewControllerDidTapApply:(id)sender {
    [self.delegate didApplyRatingFilters:[self.selectedRatingFilters copy]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button logic

- (void)setButtons {
    if ([self.selectedRatingFilters containsObject:@1]) {
        [self.oneStarButton setSelected:YES];
    }
    if ([self.selectedRatingFilters containsObject:@2]) {
        [self.twoStarButton setSelected:YES];
    }
    if ([self.selectedRatingFilters containsObject:@3]) {
        [self.threeStarButton setSelected:YES];
    }
    if ([self.selectedRatingFilters containsObject:@4]) {
        [self.fourStarButton setSelected:YES];
    }
    if ([self.selectedRatingFilters containsObject:@5]) {
        [self.fiveStarButton setSelected:YES];
    }

}

- (IBAction)ratingsFilterViewControllerDidTap5Stars:(id)sender {
    [self ratingButtonTapped:sender :@5];
}

- (IBAction)ratingsFilterViewControllerDidTap4Stars:(id)sender {
    [self ratingButtonTapped:sender :@4];
}

- (IBAction)ratingsFilterViewControllerDidTap3Stars:(id)sender {
    [self ratingButtonTapped:sender :@3];
}

- (IBAction)ratingsFilterViewControllerDidTap2Stars:(id)sender {
    [self ratingButtonTapped:sender :@2];
}

- (IBAction)ratingsFilterViewControllerDidTap1Star:(id)sender {
    [self ratingButtonTapped:sender :@1];
}

- (void)ratingButtonTapped:(id)sender :(NSNumber *)number {
    if([sender isSelected] == NO) {
        [sender setSelected:YES];
        [self.selectedRatingFilters addObject:number];
    } else {
        [sender setSelected:NO];
        [self.selectedRatingFilters removeObject:number];
    }
}

@end
