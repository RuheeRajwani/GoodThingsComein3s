//
//  CuisineFilterButtonCollectionViewCell.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 8/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CuisineFilterButtonCollectionViewCellDelegate
-(void) didTapFilterButton:(UIButton *)button;

@end

@interface CuisineFilterButtonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<CuisineFilterButtonCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;


@end

NS_ASSUME_NONNULL_END
