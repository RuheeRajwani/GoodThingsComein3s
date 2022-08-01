//
//  SignUpLoginViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/7/22.
//

#import "SignUpLoginViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"


@interface SignUpLoginViewController ()<LoginViewControllerDelegate,SignUpViewControllerDelegate>

@end

@implementation SignUpLoginViewController

- (IBAction)signUpViewControllerDidTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
}


- (IBAction)signUpViewControllerDidTapSignUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

- (void)signUpViewControllerDidDismissAfterSuccessfulSignUp {
    [self dissmissViewAndAddRestarant];
}

- (void)loginViewControllerDidDismissAfterSuccessfulLogin {
    [self dissmissViewAndAddRestarant];
}

- (void) dissmissViewAndAddRestarant {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate addLikedRestaurantToUser:[PFUser currentUser] restaurant:self.restaurantToAddToLikes];
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        LoginViewController *loginVC = [segue destinationViewController];
        loginVC.delegate= self;
    } else if ([[segue identifier] isEqualToString:@"signUpSegue"]) {
        SignUpViewController *signUpVC = [segue destinationViewController];
        signUpVC.delegate= self;
    }
}

@end
