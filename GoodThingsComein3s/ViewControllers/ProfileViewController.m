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
    
    PFUser *curr = [PFUser currentUser];
    if(curr != nil){
    NSString *greeting =@"Hi ";
    NSString *exclaimation = @"!";
    self.nameFieldToFill.text =[NSString stringWithFormat:@"%@%@%@", greeting, [PFUser currentUser].username, exclaimation];
    } else {
        [self performSegueWithIdentifier:@"profileToSignUpLogin" sender:@"profileView"];
    }
    
    
}

- (IBAction)profileViewControllerDidTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        mySceneDelegate.window.rootViewController = tabBarVC;
        
    }];
    

    
}


@end
