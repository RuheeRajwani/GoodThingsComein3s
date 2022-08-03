//
//  Restaurant.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import <Foundation/Foundation.h>
#import "UIImage+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *priceDisplayString;
@property (nonatomic) NSNumber *priceValue;
@property (nonatomic) NSString *categoriesDisplayString;
@property (nonatomic) NSArray *categoriesArray;
@property (nonatomic) NSString *displayAddress;
@property (nonatomic) UIImage *restaurantImage;
@property (nonatomic) UIImage *ratingImage;
@property (nonatomic) NSString *restaurantYelpID;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSNumber *ratingValue;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)restaurantsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
