//
//  RestaurantTableViewCell.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RestaurantTableViewCellDelegate

-(void) didTapLikeForRestaurant:(Restaurant *)restaurant;

@end

@interface RestaurantTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RestaurantTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoriesLabel;
@property (nonatomic) Restaurant *restaurant;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

NS_ASSUME_NONNULL_END
