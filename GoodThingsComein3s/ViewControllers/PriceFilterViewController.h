//
//  PriceFilterViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PriceFilterViewControllerDelegate
-(void) appliedPriceFilters:(NSArray *)selectedFilters;

@end

@interface PriceFilterViewController : UIViewController

@property (nonatomic, weak) id<PriceFilterViewControllerDelegate> delegate;
@property (nonatomic) NSArray *previouslySelectedPriceFilters;

@end

NS_ASSUME_NONNULL_END
