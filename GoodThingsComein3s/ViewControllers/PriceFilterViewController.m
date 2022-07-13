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

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.selectedPriceFilters = [[NSMutableArray alloc] init];
}
- (IBAction)priceFilterViewControllerDidTapApply:(id)sender {
    //convert selectedPriceFilters to string
    NSString *priceStringToSend = [[NSString alloc] init];
    
    if(self.selectedPriceFilters.count == 1){
        priceStringToSend = [self.selectedPriceFilters objectAtIndex:0];
    } else {
        for (int i=0; i<self.selectedPriceFilters.count; i++){
            if(i < self.selectedPriceFilters.count -1){
            priceStringToSend = [NSString stringWithFormat:@"%@%@%@", priceStringToSend, [self.selectedPriceFilters objectAtIndex:i], @","];
            } else {
            priceStringToSend = [NSString stringWithFormat:@"%@%@", priceStringToSend, [self.selectedPriceFilters objectAtIndex:i]];
            }
        }
    }
    
    [self.delegate appliedPriceFilters:priceStringToSend];
    
    //-send prices selected to home screen
    //-view to dismiss
}

- (IBAction)priceFilterViewControllerDidTap1Sign:(id)sender {
    if([sender isSelected] == NO){
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:@"1"];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:@"1"];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];

}

- (IBAction)priceFilterViewControllerDidTap2Sign:(id)sender {
    if([sender isSelected] == NO){
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:@"2"];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:@"2"];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];
}


- (IBAction)priceFilterViewControllerDidTap3Sign:(id)sender {
    if([sender isSelected] == NO){
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:@"3"];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:@"3"];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];
}

- (IBAction)priceFilterViewControllerDidTap4Sign:(id)sender {
    if([sender isSelected] == NO){
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:@"4"];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:@"4"];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];
}

@end
