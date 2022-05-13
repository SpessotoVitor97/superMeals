//
//  SMRecepies.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>

@class SMRecepiesContainer;
@class SMItemContainer;
@class SMQuantityFractionContainer;
@class SMSubItemContainer;
@class SMMainContainer;
@class SMNutritionalInformationContainer;
@class SMUnitContainer;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface SMQuantityFractionContainer : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (SMQuantityFractionContainer *)empty;
+ (SMQuantityFractionContainer *)the12;
@end

@interface SMUnitContainer : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (SMUnitContainer *)empty;
+ (SMUnitContainer *)g;
+ (SMUnitContainer *)mg;
@end

#pragma mark - Object interfaces

@interface SMRecepiesContainer : NSObject
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) SMMainContainer *main;
@property (nonatomic, strong) SMMainContainer *side;
@property (nonatomic, copy)   NSArray<SMItemContainer *> *items;
@property (nonatomic, copy)   NSString *planSize;
@property (nonatomic, copy)   NSString *planStyle;
@property (nonatomic, assign) NSInteger planStyleID;
@property (nonatomic, copy)   NSString *planTitle;
@property (nonatomic, copy)   NSString *planMobileTitle;
@property (nonatomic, copy)   NSString *planTitleWithoutSize;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface SMItemContainer : NSObject
@property (nonatomic, assign)           NSInteger identifier;
@property (nonatomic, copy)             NSString *mealNumbers;
@property (nonatomic, copy)             NSString *name;
@property (nonatomic, nullable, copy)   NSString *category;
@property (nonatomic, nullable, strong) NSNumber *alternateStore;
@property (nonatomic, assign)           BOOL isStaple;
@property (nonatomic, nullable, copy)   id sale;
@property (nonatomic, nullable, copy)   id price;
@property (nonatomic, assign)           double quantity;
@property (nonatomic, assign)           NSInteger quantityNumber;
@property (nonatomic, assign)           SMQuantityFractionContainer *quantityFraction;
@property (nonatomic, copy)             NSString *parsedName;
@property (nonatomic, nullable, copy)   NSString *size;
@property (nonatomic, nullable, copy)   NSString *sizeUnits;
@property (nonatomic, nullable, copy)   NSString *units;
@property (nonatomic, nullable, copy)   NSString *unitsFriendly;
@property (nonatomic, nullable, copy)   NSString *unitsPlural;
@property (nonatomic, nullable, copy)   id needs;
@property (nonatomic, copy)             NSString *storeBrandName;
@property (nonatomic, copy)             NSArray<SMSubItemContainer *> *subItems;
@end

@interface SMSubItemContainer : NSObject
@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, assign)         NSInteger mealNumber;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, assign)         BOOL isSide;
@property (nonatomic, nullable, copy) id sale;
@property (nonatomic, nullable, copy) id price;
@property (nonatomic, assign)         double quantity;
@property (nonatomic, assign)         NSInteger quantityNumber;
@property (nonatomic, assign)         SMQuantityFractionContainer *quantityFraction;
@property (nonatomic, nullable, copy) NSString *size;
@property (nonatomic, nullable, copy) NSString *sizeUnits;
@property (nonatomic, nullable, copy) NSString *units;
@property (nonatomic, nullable, copy) NSString *unitsFriendly;
@property (nonatomic, nullable, copy) NSString *unitsPlural;
@property (nonatomic, nullable, copy) id needs;
@end

@interface SMMainContainer : NSObject
@property (nonatomic, copy)           NSString *title;
@property (nonatomic, assign)         NSInteger calories;
@property (nonatomic, assign)         NSInteger servings;
@property (nonatomic, copy)           NSArray<SMNutritionalInformationContainer *> *nutritionalInformation;
@property (nonatomic, copy)           NSDictionary<NSString *, NSString *> *ingredients;
@property (nonatomic, copy)           NSDictionary<NSString *, NSString *> *instructions;
@property (nonatomic, copy)           NSString *notes;
@property (nonatomic, assign)         NSInteger prepTime;
@property (nonatomic, assign)         NSInteger cookTime;
@property (nonatomic, copy)           NSString *style;
@property (nonatomic, assign)         NSInteger styleID;
@property (nonatomic, assign)         NSInteger rating;
@property (nonatomic, assign)         BOOL isSide;
@property (nonatomic, nullable, copy) NSString *comment;
@property (nonatomic, copy)           NSString *bucket;
@property (nonatomic, nullable, copy) NSString *image;
@property (nonatomic, nullable, copy) NSString *primaryPicturePath;
@property (nonatomic, nullable, copy) NSString *primaryPictureURL;
@property (nonatomic, nullable, copy) NSString *primaryPictureURLMedium;
@end

@interface SMNutritionalInformationContainer : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *nameWithoutUnit;
@property (nonatomic, assign) SMUnitContainer *unit;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) BOOL isShouldCombine;
@property (nonatomic, assign) BOOL isFocus;
@end

NS_ASSUME_NONNULL_END

