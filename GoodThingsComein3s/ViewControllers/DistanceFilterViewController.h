//
//  DistanceFilterViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DistanceFilterDelegate
-(void) didApplyDistanceFilter:(NSNumber *)radius;

@end

@interface DistanceFilterViewController : UIViewController

@property (nonatomic, weak) id<DistanceFilterDelegate> delegate;
@property NSNumber *previouslySelectedRadius;

@end

NS_ASSUME_NONNULL_END
