//
//  SignUpViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignUpViewControllerDelegate

- (void)signUpViewControllerDidDismissAfterSuccessfulSignUp;

@end

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) id<SignUpViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
