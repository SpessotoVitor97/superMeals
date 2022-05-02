//
//  SMRecepies.h
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>

@class SMRecepies;
@class SMItem;
@class SMQuantityFraction;
@class SMSubItem;
@class SMMain;
@class SMNutritionalInformation;
@class SMUnit;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Boxed enums

@interface SMQuantityFraction : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (SMQuantityFraction *)empty;
+ (SMQuantityFraction *)the12;
@end

@interface SMUnit : NSObject
@property (nonatomic, readonly, copy) NSString *value;
+ (instancetype _Nullable)withValue:(NSString *)value;
+ (SMUnit *)empty;
+ (SMUnit *)g;
+ (SMUnit *)mg;
@end

#pragma mark - Object interfaces

@interface SMRecepies : NSObject
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) SMMain *main;
@property (nonatomic, strong) SMMain *side;
@property (nonatomic, copy)   NSArray<SMItem *> *items;
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

@interface SMItem : NSObject
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
@property (nonatomic, assign)           SMQuantityFraction *quantityFraction;
@property (nonatomic, copy)             NSString *parsedName;
@property (nonatomic, nullable, copy)   NSString *size;
@property (nonatomic, nullable, copy)   NSString *sizeUnits;
@property (nonatomic, nullable, copy)   NSString *units;
@property (nonatomic, nullable, copy)   NSString *unitsFriendly;
@property (nonatomic, nullable, copy)   NSString *unitsPlural;
@property (nonatomic, nullable, copy)   id needs;
@property (nonatomic, copy)             NSString *storeBrandName;
@property (nonatomic, copy)             NSArray<SMSubItem *> *subItems;
@end

@interface SMSubItem : NSObject
@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, assign)         NSInteger mealNumber;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, assign)         BOOL isSide;
@property (nonatomic, nullable, copy) id sale;
@property (nonatomic, nullable, copy) id price;
@property (nonatomic, assign)         double quantity;
@property (nonatomic, assign)         NSInteger quantityNumber;
@property (nonatomic, assign)         SMQuantityFraction *quantityFraction;
@property (nonatomic, nullable, copy) NSString *size;
@property (nonatomic, nullable, copy) NSString *sizeUnits;
@property (nonatomic, nullable, copy) NSString *units;
@property (nonatomic, nullable, copy) NSString *unitsFriendly;
@property (nonatomic, nullable, copy) NSString *unitsPlural;
@property (nonatomic, nullable, copy) id needs;
@end

@interface SMMain : NSObject
@property (nonatomic, copy)           NSString *title;
@property (nonatomic, assign)         NSInteger calories;
@property (nonatomic, assign)         NSInteger servings;
@property (nonatomic, copy)           NSArray<SMNutritionalInformation *> *nutritionalInformation;
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

@interface SMNutritionalInformation : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *nameWithoutUnit;
@property (nonatomic, assign) SMUnit *unit;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) BOOL isShouldCombine;
@property (nonatomic, assign) BOOL isFocus;
@end

NS_ASSUME_NONNULL_END

