//
//  PriceFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "PriceFilterViewController.h"

@interface PriceFilterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *oneDollarSignButton;
@property (weak, nonatomic) IBOutlet UIButton *twoDollarSignButton;
@property (weak, nonatomic) IBOutlet UIButton *threeDollarSignButton;
@property (weak, nonatomic) IBOutlet UIButton *fourDollarSignButton;
@property (nonatomic) NSMutableArray *selectedPriceFilters;

@end

@implementation PriceFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedPriceFilters = [self.previouslySelectedPriceFilters mutableCopy];
    [self setButtons];
}

- (IBAction)priceFilterViewControllerDidTapApply:(id)sender {
    [self.delegate didApplyPriceFilters:[self.selectedPriceFilters copy]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button logic

-(void)setButtons {    
    if ([self.selectedPriceFilters containsObject:@1]) {
        [self.oneDollarSignButton setSelected:YES];
    }
    if ([self.selectedPriceFilters containsObject:@2]) {
        [self.twoDollarSignButton setSelected:YES];
    }
    if ([self.selectedPriceFilters containsObject:@3]) {
        [self.threeDollarSignButton setSelected:YES];
    }
    if ([self.selectedPriceFilters containsObject:@4]) {
        [self.fourDollarSignButton setSelected:YES];
    }
}

- (IBAction)priceFilterViewControllerDidTap1Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@1];
}

- (IBAction)priceFilterViewControllerDidTap2Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@2];
}


- (IBAction)priceFilterViewControllerDidTap3Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@3];
}

- (IBAction)priceFilterViewControllerDidTap4Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@4];
}

- (void)dollarSignButtonTapped:(id)sender :(NSNumber *)filterToAdd {
    if([sender isSelected] == NO) {
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:filterToAdd];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:filterToAdd];
    }
}

@end
