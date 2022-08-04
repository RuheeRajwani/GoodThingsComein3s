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
@property (nonatomic) NSDictionary *cuisineFilterDictionary;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end

@implementation CuisineFilterViewController

- (IBAction)didTapApply:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didApplyCuisineFilters:self.selectedCuisineFilters categoriesParamRequestString:[self _getCategoriesParamRequestString]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.cuisineFilterButtonCollectionView.dataSource = self;
    self.cuisineFilterButtonCollectionView.delegate = self;
    
    self.selectedCuisineFilters = [self.previouslySelectedCuisineFilters mutableCopy];
    self.cuisineButtonText = [NSArray arrayWithObjects:@"Afghan",@"American (New)",@"American (Traditional)", @"Brazilian",@"Chinese",@"Ethiopian",@"French",@"Filipino",@"Greek",@"Indian",@"Italian", @"Japanese", @"Korean",@"Mediterranean", @"Mexican",@"Pakistani",@"Turkish", nil];
    self.cuisineFilterDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"afghani",@"newamerican",@"tradamerican",@"brazilian",@"chinese",@"ethiopian", @"french", @"filipino", @"greek", @"indpak", @"italian", @"japanese", @"korean",  @"mediterranean",@"mexican",@"pakistani", @"turkish", nil] forKeys:self.cuisineButtonText];
}

- (NSString *)_getCategoriesParamRequestString {
    NSString *paramString;
    if (self.selectedCuisineFilters.count >0){
    paramString = self.cuisineFilterDictionary[self.selectedCuisineFilters[0]];
        for (int i=1; i<self.selectedCuisineFilters.count;i++){
            paramString =[NSString stringWithFormat:@"%@%@%@",paramString,@",",self.cuisineFilterDictionary[self.selectedCuisineFilters[i]] ];
        }
    }
    return paramString;
}

- (void)didTapFilterButton:(UIButton *)button{
    if ([self.selectedCuisineFilters containsObject:button.titleLabel.text]){
        [self.selectedCuisineFilters removeObject:button.titleLabel.text];
        [button setSelected:NO];
    } else {
        [self.selectedCuisineFilters addObject:button.titleLabel.text];
        [button setSelected:YES];
    }
}

#pragma mark - Collection view

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

@end
