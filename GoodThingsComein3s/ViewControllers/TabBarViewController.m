//
//  TabBarViewController.m
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/7/22.
//

#import "TabBarViewController.h"
#import "SearchViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SignUpLoginViewController.h"



@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(PFUser.currentUser != nil){
    [self updateViewControllers];
    }
}

-(void) updateViewControllers{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    HomeViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    ProfileViewController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self setViewControllers:@[searchVC, homeVC, profileVC]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
