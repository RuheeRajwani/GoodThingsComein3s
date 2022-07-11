//
//  LoginViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SearchViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController


- (IBAction)loginViewControllerDidTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
       
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
    if (error != nil) {
        NSLog(@"User log in failed: %@", error.localizedDescription);
    } else {
        NSLog(@"User logged in successfully");
        [self performSegueWithIdentifier:@"loginToProfileSegue" sender:nil];
        
           }
       }];
}



@end
