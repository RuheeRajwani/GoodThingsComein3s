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
-(void) signUpLoginViewControllerDidDismissForUser;

@end

@interface SignUpLoginViewController : UIViewController

@property (nonatomic, weak) id<SignUpLoginViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
