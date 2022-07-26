//
//  RestaurantCollectionViewCell.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/21/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (nonatomic) PFObject *restaurant;

@end

NS_ASSUME_NONNULL_END
