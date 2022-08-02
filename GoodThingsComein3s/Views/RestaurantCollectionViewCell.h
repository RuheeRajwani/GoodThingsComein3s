//
//  RestaurantCollectionViewCell.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (nonatomic) Restaurant *restaurant;

@end

NS_ASSUME_NONNULL_END
