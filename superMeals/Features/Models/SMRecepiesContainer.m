//
//  SMRecepies.m
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import "SMRecepiesContainer.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface SMRecepiesContainer (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMItemContainer (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMSubItemContainer (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMMainContainer (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMNutritionalInformationContainer (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

// These enum-like reference types are needed so that enum
// values can be contained by NSArray and NSDictionary.

@implementation SMQuantityFractionContainer
+ (NSDictionary<NSString *, SMQuantityFractionContainer *> *)values
{
    static NSDictionary<NSString *, SMQuantityFractionContainer *> *values;
    return values = values ? values : @{
        @"": [[SMQuantityFractionContainer alloc] initWithValue:@""],
        @"1/2": [[SMQuantityFractionContainer alloc] initWithValue:@"1/2"],
    };
}

+ (SMQuantityFractionContainer *)empty { return SMQuantityFractionContainer.values[@""]; }
+ (SMQuantityFractionContainer *)the12 { return SMQuantityFractionContainer.values[@"1/2"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return SMQuantityFractionContainer.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation SMUnitContainer
+ (NSDictionary<NSString *, SMUnitContainer *> *)values
{
    static NSDictionary<NSString *, SMUnitContainer *> *values;
    return values = values ? values : @{
        @"": [[SMUnitContainer alloc] initWithValue:@""],
        @"g": [[SMUnitContainer alloc] initWithValue:@"g"],
        @"mg": [[SMUnitContainer alloc] initWithValue:@"mg"],
    };
}

+ (SMUnitContainer *)empty { return SMUnitContainer.values[@""]; }
+ (SMUnitContainer *)g { return SMUnitContainer.values[@"g"]; }
+ (SMUnitContainer *)mg { return SMUnitContainer.values[@"mg"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return SMUnitContainer.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

SMRecepiesContainer *_Nullable SMRecepiesFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [SMRecepiesContainer fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

SMRecepiesContainer *_Nullable SMRecepiesFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return SMRecepiesFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable SMRecepiesToData(SMRecepiesContainer *recepies, NSError **error)
{
    @try {
        id json = [recepies JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable SMRecepiesToJSON(SMRecepiesContainer *recepies, NSStringEncoding encoding, NSError **error)
{
    NSData *data = SMRecepiesToData(recepies, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation SMRecepiesContainer
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"main": @"main",
        @"side": @"side",
        @"items": @"items",
        @"plan_size": @"planSize",
        @"plan_style": @"planStyle",
        @"plan_style_id": @"planStyleID",
        @"plan_title": @"planTitle",
        @"plan_mobile_title": @"planMobileTitle",
        @"plan_title_without_size": @"planTitleWithoutSize",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return SMRecepiesFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return SMRecepiesFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[SMRecepiesContainer alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _main = [SMMainContainer fromJSONDictionary:(id)_main];
        _side = [SMMainContainer fromJSONDictionary:(id)_side];
        _items = map(_items, λ(id x, [SMItemContainer fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMRecepiesContainer.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMRecepiesContainer.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMRecepiesContainer.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMRecepiesContainer.properties) {
        id propertyName = SMRecepiesContainer.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"main": [_main JSONDictionary],
        @"side": [_side JSONDictionary],
        @"items": map(_items, λ(id x, [x JSONDictionary])),
    }];

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return SMRecepiesToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return SMRecepiesToJSON(self, encoding, error);
}
@end

@implementation SMItemContainer
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"meal_numbers": @"mealNumbers",
        @"name": @"name",
        @"category": @"category",
        @"alternate_store": @"alternateStore",
        @"is_staple": @"isStaple",
        @"sale": @"sale",
        @"price": @"price",
        @"quantity": @"quantity",
        @"quantity_number": @"quantityNumber",
        @"quantity_fraction": @"quantityFraction",
        @"parsed_name": @"parsedName",
        @"size": @"size",
        @"size_units": @"sizeUnits",
        @"units": @"units",
        @"units_friendly": @"unitsFriendly",
        @"units_plural": @"unitsPlural",
        @"needs": @"needs",
        @"store_brand_name": @"storeBrandName",
        @"sub_items": @"subItems",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[SMItemContainer alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _quantityFraction = [SMQuantityFractionContainer withValue:(id)_quantityFraction];
        _subItems = map(_subItems, λ(id x, [SMSubItemContainer fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMItemContainer.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMItemContainer.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMItemContainer.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMItemContainer.properties) {
        id propertyName = SMItemContainer.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"is_staple": _isStaple ? @YES : @NO,
        @"quantity_fraction": [_quantityFraction value],
        @"sub_items": map(_subItems, λ(id x, [x JSONDictionary])),
    }];

    return dict;
}
@end

@implementation SMSubItemContainer
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"id": @"identifier",
        @"meal_number": @"mealNumber",
        @"name": @"name",
        @"is_side": @"isSide",
        @"sale": @"sale",
        @"price": @"price",
        @"quantity": @"quantity",
        @"quantity_number": @"quantityNumber",
        @"quantity_fraction": @"quantityFraction",
        @"size": @"size",
        @"size_units": @"sizeUnits",
        @"units": @"units",
        @"units_friendly": @"unitsFriendly",
        @"units_plural": @"unitsPlural",
        @"needs": @"needs",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[SMSubItemContainer alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _quantityFraction = [SMQuantityFractionContainer withValue:(id)_quantityFraction];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMSubItemContainer.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMSubItemContainer.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMSubItemContainer.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMSubItemContainer.properties) {
        id propertyName = SMSubItemContainer.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"is_side": _isSide ? @YES : @NO,
        @"quantity_fraction": [_quantityFraction value],
    }];

    return dict;
}
@end

@implementation SMMainContainer
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"title": @"title",
        @"calories": @"calories",
        @"servings": @"servings",
        @"nutritional_information": @"nutritionalInformation",
        @"ingredients": @"ingredients",
        @"instructions": @"instructions",
        @"notes": @"notes",
        @"prep_time": @"prepTime",
        @"cook_time": @"cookTime",
        @"style": @"style",
        @"style_id": @"styleID",
        @"rating": @"rating",
        @"is_side": @"isSide",
        @"comment": @"comment",
        @"bucket": @"bucket",
        @"image": @"image",
        @"primary_picture_path": @"primaryPicturePath",
        @"primary_picture_url": @"primaryPictureURL",
        @"primary_picture_url_medium": @"primaryPictureURLMedium",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[SMMainContainer alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _nutritionalInformation = map(_nutritionalInformation, λ(id x, [SMNutritionalInformationContainer fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMMainContainer.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMMainContainer.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMMainContainer.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMMainContainer.properties) {
        id propertyName = SMMainContainer.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"nutritional_information": map(_nutritionalInformation, λ(id x, [x JSONDictionary])),
        @"is_side": _isSide ? @YES : @NO,
    }];

    return dict;
}
@end

@implementation SMNutritionalInformationContainer
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"name": @"name",
        @"name_without_unit": @"nameWithoutUnit",
        @"unit": @"unit",
        @"value": @"value",
        @"order": @"order",
        @"should_combine": @"isShouldCombine",
        @"focus": @"isFocus",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[SMNutritionalInformationContainer alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _unit = [SMUnitContainer withValue:(id)_unit];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMNutritionalInformationContainer.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMNutritionalInformationContainer.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMNutritionalInformationContainer.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMNutritionalInformationContainer.properties) {
        id propertyName = SMNutritionalInformationContainer.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"unit": [_unit value],
        @"should_combine": _isShouldCombine ? @YES : @NO,
        @"focus": _isFocus ? @YES : @NO,
    }];

    return dict;
}
@end

NS_ASSUME_NONNULL_END
