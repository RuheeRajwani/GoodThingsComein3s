//
//  CuisineFilterViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import "CuisineFilterViewController.h"
#import "CuisineFilterButtonCollectionViewCell.h"

@interface CuisineFilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CuisineFilterButtonCollectionViewCellDelegate>

@property NSArray *cuisineButtonText;
@property (weak, nonatomic) IBOutlet UICollectionView *cuisineFilterButtonCollectionView;
@property (nonatomic) NSMutableArray *selectedCuisineFilters;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;


@end


@implementation CuisineFilterViewController

- (IBAction)didTapApply:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didApplyCuisineFilters:self.selectedCuisineFilters];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.selectedCuisineFilters = [self.previouslySelectedCuisineFilters mutableCopy];
    
    self.cuisineButtonText = [NSArray arrayWithObjects:@"American (New)",@"American (Traditional)", @"Afghan", @"Brazilian", @"Chinese", @"Ethiopian", @"French", @"Filipino", @"Greek", @"Indian", @"Italian", @"Japanese", @"Korean", @"Mediterranean", @"Mexican", @"Turkish", nil];
    
    self.cuisineFilterButtonCollectionView.dataSource = self;
    self.cuisineFilterButtonCollectionView.delegate = self;
    
    [self.applyButton setEnabled:self.selectedCuisineFilters.count != 0];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CuisineFilterButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CuisineFilterButtonCollectionViewCell" forIndexPath:indexPath];
    if([self.selectedCuisineFilters containsObject:self.cuisineButtonText[indexPath.row]]){
        [cell.filterButton setSelected:YES];
    }
    cell.delegate = self;
    [cell.filterButton setTitle:self.cuisineButtonText[indexPath.row] forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cuisineButtonText.count;
}

- (void)didTapFilterButton:(UIButton *)button{
    if ([self.selectedCuisineFilters containsObject:button.titleLabel.text]){
        [self.selectedCuisineFilters removeObject:button.titleLabel.text];
        [button setSelected:NO];
    } else {
        [self.selectedCuisineFilters addObject:button.titleLabel.text];
        [button setSelected:YES];
    }
    [self.applyButton setEnabled:self.selectedCuisineFilters.count != 0];
}





@end
