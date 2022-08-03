//
//  DistanceFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "DistanceFilterViewController.h"

@interface DistanceFilterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceSliderValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (nonatomic) NSNumber *radius;

@end

@implementation DistanceFilterViewController

- (void)viewDidLoad {
    self.radius = self.previouslySelectedRadius;
    if (self.radius != nil){
        [self.distanceSlider setValue:self.radius.floatValue];
        [self.applyButton setEnabled:YES];
        [self.distanceSliderValueLabel setHidden:NO];
        [self.distanceSliderValueLabel setText:[NSString stringWithFormat:@"%@%f%@", @"Selected distance: ", self.distanceSlider.value, @" miles"]];
    }
}

- (IBAction)distanceFilterViewControllerDidTapApply:(id)sender {
    self.radius = [NSNumber numberWithFloat:self.distanceSlider.value];
    [self.delegate didApplyDistanceFilter:self.radius];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)distanceSliderValueDidChange:(id)sender {
    [self.applyButton setEnabled:YES];
    [self.distanceSliderValueLabel setHidden:NO];
    [self.distanceSliderValueLabel setText:[NSString stringWithFormat:@"%@%f%@", @"Selected distance: ", self.distanceSlider.value, @" miles"]];
}

@end
