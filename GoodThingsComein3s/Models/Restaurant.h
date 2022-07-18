//
//  Restaurant.h
//  GoodThingsComein3s
//
//  Created by Ruhee Rajwani on 7/18/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *price;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSArray *categories;
@property (nonatomic) NSArray *displayAddress;
@property (nonatomic) NSString *imageURL; 



- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)restaurantsWithArray:(NSArray *)dictionaries;


@end

NS_ASSUME_NONNULL_END
