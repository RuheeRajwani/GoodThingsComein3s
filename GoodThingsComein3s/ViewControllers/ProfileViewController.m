//
//  ProfileViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/6/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "TabBarViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameFieldToFill;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *greeting =@"Hi ";
    NSString *exclaimation = @"!";
    self.nameFieldToFill.text =[NSString stringWithFormat:@"%@%@%@", greeting, [PFUser currentUser].username, exclaimation];
    
    
}

- (IBAction)profileViewControllerDidTapLogout:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
}


@end
