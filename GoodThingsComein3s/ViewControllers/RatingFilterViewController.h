//
//  RatingFilterViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RatingFilterViewControllerDelegate

- (void)didApplyRatingFilters:(NSArray *)selectedFilters;

@end

@interface RatingFilterViewController : UIViewController

@property (nonatomic,weak) id<RatingFilterViewControllerDelegate> delegate;
@property (nonatomic) NSArray *previouslySelectedRatingFilters;

@end

NS_ASSUME_NONNULL_END
