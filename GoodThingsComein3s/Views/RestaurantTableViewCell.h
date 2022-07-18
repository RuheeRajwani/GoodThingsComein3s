//
//  RestaurantTableViewCell.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoriesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic) Restaurant *restaurant;

@end

NS_ASSUME_NONNULL_END
