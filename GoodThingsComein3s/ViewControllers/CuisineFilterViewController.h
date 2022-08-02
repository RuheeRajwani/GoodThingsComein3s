//
//  CuisineFilterViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CuisineFilterDelegate
-(void) didApplyCuisineFilters:(NSArray *)selectedFilters;

@end

@interface CuisineFilterViewController : UIViewController

@property (nonatomic, weak) id<CuisineFilterDelegate> delegate;
@property (nonatomic) NSArray *previouslySelectedCuisineFilters;

@end

NS_ASSUME_NONNULL_END
