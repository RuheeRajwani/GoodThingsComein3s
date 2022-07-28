//
//  SignUpLoginViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/7/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SignUpLoginViewControllerDelegate
-(void) addLikedRestaurantToUser:(PFUser *)currUser restaurant:(Restaurant *)restaurant;

@end

@interface SignUpLoginViewController : UIViewController

@property (nonatomic, weak) id<SignUpLoginViewControllerDelegate> delegate;
@property (nonatomic) Restaurant *restaurantToAddToLikes;


@end

NS_ASSUME_NONNULL_END
