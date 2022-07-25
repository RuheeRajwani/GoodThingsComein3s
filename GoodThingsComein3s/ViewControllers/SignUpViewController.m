//
//  SignUpViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@end

@implementation SignUpViewController

- (IBAction)signUpViewControllerDidTapSignUp:(id)sender {
    PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.email = self.emailField.text;
        newUser.password = self.passwordField.text;
        newUser[@"location"] = self.locationField.text;
        newUser[@"likedRestaurants"] = [[NSArray alloc]init];
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                [self dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"view dismissed");
                    [self.delegate dismissLoginSignUpFromSignUp];
                }];
                
            }
        }];
}

@end
