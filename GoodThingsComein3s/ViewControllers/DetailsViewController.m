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

@interface DetailsViewController () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantPhotosCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantRatingImageView;
@property (nonatomic) NSDictionary *restaurantToShow;
@property (nonatomic) NSMutableArray *imageURLS;
@property (weak, nonatomic) IBOutlet UIPageControl *restaurantImageCollectionViewPageControl;
@property (nonatomic) int currentIndex;
@property (nonatomic) NSTimer *timer;

@end

@implementation DetailsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.restaurantPhotosCollectionView.delegate = self;
    self.restaurantPhotosCollectionView.dataSource = self;

    self.imageURLS = [[NSMutableArray alloc] init];
    
    [[APIManager shared] getRestaurantDetails:self.yelpRestaurantID completion:^(NSDictionary * _Nonnull restaurant, NSError * _Nonnull error) {
        if(error == nil){
        self.restaurantToShow = restaurant;
        [self setView];
        }
    }];
}

-(void) setView {
    self.restaurantNameLabel.text = self.restaurantToShow[@"name"];
    self.restaurantPriceLabel.text = self.restaurantToShow[@"price"];
    
    NSArray *categories = self.restaurantToShow[@"categories"];
    NSString *categoryString = categories[0][@"title"];
    for(int i=1; i<categories.count; i++){
        categoryString = [NSString stringWithFormat:@"%@%@%@", categoryString,@", ",categories[i][@"title"] ];
    }
    self.restaurantCategoriesLabel.text = categoryString;
    
    NSString *locationLabelText = [[NSString alloc] init];
    for(NSString *partOfLocation in self.restaurantToShow[@"location"][@"display_address"]){
        if([locationLabelText isEqualToString:@""]){
            locationLabelText = partOfLocation;
        } else {
            locationLabelText = [NSString stringWithFormat:@"%@%@%@", locationLabelText,@", " ,partOfLocation];
        }
    }
    self.restaurantAddressLabel.text = locationLabelText;
    
    NSNumber *rating = self.restaurantToShow[@"rating"];
    int ratingValue = (int)(rating.doubleValue +.5);
    
    if(ratingValue == 1){
        self.restaurantRatingImageView.image = [UIImage imageNamed:@"1StarWhiteBackground"];
        
    } else if (ratingValue == 2){
        self.restaurantRatingImageView.image = [UIImage imageNamed:@"2StarsWhiteBackground"];
        
    } else if (ratingValue == 3){
        self.restaurantRatingImageView.image = [UIImage imageNamed:@"3StarsWhiteBackground"];
        
    }else if (ratingValue == 4){
        self.restaurantRatingImageView.image = [UIImage imageNamed:@"4StarsWhiteBackground"];
        
    }else if(ratingValue == 5){
        self.restaurantRatingImageView.image = [UIImage imageNamed:@"5StarsWhiteBackground"];
    }
    
    for(NSObject *imageURL in self.restaurantToShow[@"photos"]){
        NSString *urlString = (NSString *)imageURL;
        [self.imageURLS addObject:[NSURL URLWithString:urlString]];
    }
    
    self.restaurantImageCollectionViewPageControl.numberOfPages = self.imageURLS.count;
    self.currentIndex = 0;
        
    [self.restaurantPhotosCollectionView reloadData];
    [self startTimeThread];
    
}

-(void) startTimeThread {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

-(void) timerAction{
    int desiredScrollPosition = (self.currentIndex <self.imageURLS.count - 1) ? self.currentIndex + 1 : 0;
    [self.restaurantPhotosCollectionView setNeedsLayout];
    [self.restaurantPhotosCollectionView layoutIfNeeded];
    [self.restaurantPhotosCollectionView setContentOffset:CGPointMake(desiredScrollPosition*self.restaurantPhotosCollectionView.frame.size.width, 0) animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentIndex = scrollView.contentOffset.x / self.restaurantPhotosCollectionView.frame.size.width;
    self.restaurantImageCollectionViewPageControl.currentPage = self.currentIndex;
}

@end
