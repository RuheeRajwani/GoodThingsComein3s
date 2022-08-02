//
//  LoginViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewControllerDelegate
- (void)loginViewControllerDidDismissAfterSuccessfulLogin;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
