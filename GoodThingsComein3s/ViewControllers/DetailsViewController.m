//
//  DetailsViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/28/22.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "RestaurantPhotoCollectionViewCell.h"
#import "RestaurantReviewTableViewCell.h"
#import "Restaurant.h"
#import "DGActivityIndicatorView.h"

@interface DetailsViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantPhotosCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantRatingImageView;
@property (nonatomic) NSMutableArray *imageURLS;
@property (nonatomic) NSArray *reviews;
@property (weak, nonatomic) IBOutlet UIPageControl *restaurantImageCollectionViewPageControl;
@property (nonatomic) int currentIndex;
@property (nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *restaurantReviewsTableView;
@property (nonatomic) NSDictionary *additionalRestaurantDetails;
@property (nonatomic) DGActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIStackView *labelStackView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsTitleLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restaurantPhotosCollectionView.delegate = self;
    self.restaurantPhotosCollectionView.dataSource = self;
    
    self.restaurantReviewsTableView.delegate = self;
    self.restaurantReviewsTableView.dataSource = self;

    self.imageURLS = [[NSMutableArray alloc] init];
    
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulseSync tintColor:[UIColor colorWithRed:45/255.0 green:121/255.0 blue:253/255.0 alpha:1.0] size:50.0f];
    self.activityIndicatorView.frame = CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50.0f, 50.0f);
    [self.view addSubview:self.activityIndicatorView];
    
    [self _hideShowViewElements:YES];
    [self.activityIndicatorView startAnimating];
    
    [[APIManager shared] getRestaurantDetails:self.restaurantToShow.restaurantYelpID completion:^(NSDictionary * _Nonnull restaurant, NSError * _Nonnull error) {
        if (error == nil) {
        self.additionalRestaurantDetails = restaurant;
        [self _setRestaurantView];
        }
    }];

    [[APIManager shared] getRestaurantReviews:self.restaurantToShow.restaurantYelpID completion:^(NSArray * _Nonnull reviews, NSError * _Nonnull error) {
        if (error == nil) {
            self.reviews = reviews;
            [self.restaurantReviewsTableView reloadData];
            [self.activityIndicatorView stopAnimating];
            [self _hideShowViewElements:NO];
        }
    }];
}

#pragma mark - Timer 

- (void)_startTimeThread {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void) timerAction {
    int desiredScrollPosition = (self.currentIndex <self.imageURLS.count - 1) ? self.currentIndex + 1 : 0;
    [self.restaurantPhotosCollectionView setNeedsLayout];
    [self.restaurantPhotosCollectionView layoutIfNeeded];
    [self.restaurantPhotosCollectionView setContentOffset:CGPointMake(desiredScrollPosition*self.restaurantPhotosCollectionView.frame.size.width, 0) animated:YES];
}

#pragma mark - Helper Methods

- (void)_hideShowViewElements:(Boolean)toHide {
    [self.restaurantNameLabel setHidden:toHide];
    [self.restaurantImageCollectionViewPageControl setHidden:toHide];
    [self.activityIndicatorView setHidden:!toHide];
    [self.labelStackView setHidden:toHide];
    [self.reviewsTitleLabel setHidden:toHide];
    
}

- (void)_setRestaurantView {
    self.restaurantNameLabel.text = self.restaurantToShow.name;
    self.restaurantPriceLabel.text = self.restaurantToShow.priceDisplayString;
    self.restaurantCategoriesLabel.text = self.restaurantToShow.categoriesDisplayString;
    self.restaurantAddressLabel.text = self.restaurantToShow.displayAddress;
    self.restaurantRatingImageView.image = self.restaurantToShow.ratingImage;
    
    for (NSObject *imageURL in self.additionalRestaurantDetails[@"photos"]) {
        NSString *urlString = (NSString *)imageURL;
        [self.imageURLS addObject:[NSURL URLWithString:urlString]];
    }
    
    self.restaurantImageCollectionViewPageControl.numberOfPages = self.imageURLS.count;
    self.currentIndex = 0;
        
    [self.restaurantPhotosCollectionView reloadData];
    [self _startTimeThread];
}

#pragma mark - Image Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLS.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantPhotoCollectionViewCell" forIndexPath:indexPath];
    
    NSString *restaurantImageURLString = [NSString stringWithFormat:@"%@",self.imageURLS[indexPath.row]];
    NSURL *restaurantImageURL = [NSURL URLWithString: restaurantImageURLString];
    NSData *restaurantImageData = [NSData dataWithContentsOfURL:restaurantImageURL];
    cell.restaurantSlideImage.image = [UIImage imageWithData:restaurantImageData];
    
    cell.restaurantSlideImage.contentMode= UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / self.restaurantPhotosCollectionView.frame.size.width;
    self.restaurantImageCollectionViewPageControl.currentPage = self.currentIndex;
}

#pragma mark - Reviews Table View

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RestaurantReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantReviewTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *review = self.reviews[indexPath.row];
    
    cell.restaurantReviewUsernameLabel.text = review[@"user"][@"name"];
    cell.restaurantReviewTextLabel.text = review[@"text"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

@end
