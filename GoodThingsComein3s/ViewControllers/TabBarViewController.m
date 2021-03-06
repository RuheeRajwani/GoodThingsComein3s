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
    self.navigationItem.hidesBackButton = YES;
    }

-(void) updateViewControllers{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewControllerNav"];
    UINavigationController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerNav"];
    UINavigationController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewControllerNav"];
    UINavigationController *signUpLoginVC = [storyboard instantiateViewControllerWithIdentifier:@"signUpLoginViewControllerNav"];

    if (PFUser.currentUser != nil){
        [self setViewControllers:@[searchVC, homeVC, profileVC]];
        [self setSelectedIndex:2];
    }else {
        [self setViewControllers:@[searchVC, homeVC, signUpLoginVC]];
        [self setSelectedIndex:1];
    }
    
    
}





@end
