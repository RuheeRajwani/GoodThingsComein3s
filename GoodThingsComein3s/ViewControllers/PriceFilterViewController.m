//
//  PriceFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "PriceFilterViewController.h"

@interface PriceFilterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *oneSignButton;
@property (weak, nonatomic) IBOutlet UIButton *twoSignButton;
@property (weak, nonatomic) IBOutlet UIButton *threeSignButton;
@property (weak, nonatomic) IBOutlet UIButton *fourSignButton;


@property (nonatomic) NSMutableArray *selectedPriceFilters;



@end

@implementation PriceFilterViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.selectedPriceFilters = [[NSMutableArray alloc] init];
    
    if(self.alreadySelectedFilters != nil){
        [self.applyButton setEnabled:YES];
        
        for(int i=0; i<self.alreadySelectedFilters.length; i++){
            NSString *currChar = [NSString stringWithFormat:@"%c", [self.alreadySelectedFilters characterAtIndex:i]];
            if([currChar isEqualToString:@"1"]){
                [self.selectedPriceFilters addObject:@"1"];
                [self.oneSignButton setSelected:YES];
            } else if([currChar isEqualToString:@"2"]){
                [self.selectedPriceFilters addObject:@"2"];
                [self.twoSignButton setSelected:YES];
            } else if ([currChar isEqualToString:@"3"]){
                [self.selectedPriceFilters addObject:@"3"];
                [self.threeSignButton setSelected:YES];
            } else if ([currChar isEqualToString:@"4"]){
                [self.selectedPriceFilters addObject:@"4"];
                [self.fourSignButton setSelected:YES];
            }
        }
    }
}
    
- (IBAction)priceFilterViewControllerDidTapApply:(id)sender {
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

-(void)dollarSignButtonTapped:(id)sender :(NSString *)number{
    if([sender isSelected] == NO){
        [sender setSelected:YES];
        [self.selectedPriceFilters addObject:number];
    } else {
        [sender setSelected:NO];
        [self.selectedPriceFilters removeObject:number];
    }
    [self.applyButton setEnabled:self.selectedPriceFilters.count != 0];
}


@end
