//
//  PriceFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "PriceFilterViewController.h"

@interface PriceFilterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (nonatomic) NSMutableArray *selectedPriceFilters;



@end

@implementation PriceFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedPriceFilters = [[NSMutableArray alloc] init];
}
- (IBAction)priceFilterViewControllerDidTapApply:(id)sender {
    NSString *priceStringToSend = [[NSString alloc] init];
    
    if (self.selectedPriceFilters.count == 1) {
        priceStringToSend = [self.selectedPriceFilters objectAtIndex:0];
    } else {
        for (int i=0; i<self.selectedPriceFilters.count; i++) {
            if (i < self.selectedPriceFilters.count -1) {
            priceStringToSend = [NSString stringWithFormat:@"%@%@%@", priceStringToSend, [self.selectedPriceFilters objectAtIndex:i], @","];
            } else {
            priceStringToSend = [NSString stringWithFormat:@"%@%@", priceStringToSend, [self.selectedPriceFilters objectAtIndex:i]];
            }
        }
    }
    [self.delegate appliedPriceFilters:priceStringToSend];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}

- (IBAction)priceFilterViewControllerDidTap1Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@"1"];
}

- (IBAction)priceFilterViewControllerDidTap2Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@"2"];
}


- (IBAction)priceFilterViewControllerDidTap3Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@"3"];
}

- (IBAction)priceFilterViewControllerDidTap4Sign:(id)sender {
    [self dollarSignButtonTapped:sender :@"4"];
}

- (void)dollarSignButtonTapped:(id)sender :(NSString *)number {
    if([sender isSelected] == NO) {
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:number];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:number];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];
}

@end
