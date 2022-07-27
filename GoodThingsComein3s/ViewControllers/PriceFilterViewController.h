//
//  PriceFilterViewController.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PriceFilterViewControllerDelegate
-(void) appliedPriceFilters:(NSString *)priceStringToSend;

@end

@interface PriceFilterViewController : UIViewController

@property (nonatomic, weak) id<PriceFilterViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
