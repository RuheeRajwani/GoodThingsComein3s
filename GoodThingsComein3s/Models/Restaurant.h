//
//  Restaurant.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import "UIImage+AFNetworking.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *categories;
@property (nonatomic) NSString *displayAddress;
@property (nonatomic) UIImage *restaurantImage;
@property (nonatomic) UIImage *ratingImage;



- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)restaurantsWithArray:(NSArray *)dictionaries;


@end

NS_ASSUME_NONNULL_END
