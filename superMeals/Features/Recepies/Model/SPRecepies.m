//
//  SPRecepies.m
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import "SMRecepies.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface SMRecepies (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMItem (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMSubItem (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMMain (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface SMNutritionalInformation (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

// These enum-like reference types are needed so that enum
// values can be contained by NSArray and NSDictionary.

@implementation SMQuantityFraction
+ (NSDictionary<NSString *, SMQuantityFraction *> *)values
{
    static NSDictionary<NSString *, SMQuantityFraction *> *values;
    return values = values ? values : @{
        @"": [[SMQuantityFraction alloc] initWithValue:@""],
        @"1/2": [[SMQuantityFraction alloc] initWithValue:@"1/2"],
    };
}

+ (SMQuantityFraction *)empty { return SMQuantityFraction.values[@""]; }
+ (SMQuantityFraction *)the12 { return SMQuantityFraction.values[@"1/2"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return SMQuantityFraction.values[value];
}

- (instancetype)initWithValue:(NSString *)value
{
    if (self = [super init]) _value = value;
    return self;
}

- (NSUInteger)hash { return _value.hash; }
@end

@implementation SMUnit
+ (NSDictionary<NSString *, SMUnit *> *)values
{
    static NSDictionary<NSString *, SMUnit *> *values;
    return values = values ? values : @{
        @"": [[SMUnit alloc] initWithValue:@""],
        @"g": [[SMUnit alloc] initWithValue:@"g"],
        @"mg": [[SMUnit alloc] initWithValue:@"mg"],
    };
}

+ (SMUnit *)empty { return SMUnit.values[@""]; }
+ (SMUnit *)g { return SMUnit.values[@"g"]; }
+ (SMUnit *)mg { return SMUnit.values[@"mg"]; }

+ (instancetype _Nullable)withValue:(NSString *)value
{
    return SMUnit.values[value];
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

SMRecepies *_Nullable SMRecepiesFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [SMRecepies fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

SMRecepies *_Nullable SMRecepiesFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return SMRecepiesFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable SMRecepiesToData(SMRecepies *recepies, NSError **error)
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

NSString *_Nullable SMRecepiesToJSON(SMRecepies *recepies, NSStringEncoding encoding, NSError **error)
{
    NSData *data = SMRecepiesToData(recepies, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation SMRecepies
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
    return dict ? [[SMRecepies alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _main = [SMMain fromJSONDictionary:(id)_main];
        _side = [SMMain fromJSONDictionary:(id)_side];
        _items = map(_items, λ(id x, [SMItem fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMRecepies.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMRecepies.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMRecepies.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMRecepies.properties) {
        id propertyName = SMRecepies.properties[jsonName];
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

@implementation SMItem
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
    return dict ? [[SMItem alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _quantityFraction = [SMQuantityFraction withValue:(id)_quantityFraction];
        _subItems = map(_subItems, λ(id x, [SMSubItem fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMItem.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMItem.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMItem.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMItem.properties) {
        id propertyName = SMItem.properties[jsonName];
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

@implementation SMSubItem
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
    return dict ? [[SMSubItem alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _quantityFraction = [SMQuantityFraction withValue:(id)_quantityFraction];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMSubItem.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMSubItem.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMSubItem.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMSubItem.properties) {
        id propertyName = SMSubItem.properties[jsonName];
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

@implementation SMMain
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
    return dict ? [[SMMain alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _nutritionalInformation = map(_nutritionalInformation, λ(id x, [SMNutritionalInformation fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMMain.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMMain.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMMain.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMMain.properties) {
        id propertyName = SMMain.properties[jsonName];
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

@implementation SMNutritionalInformation
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
    return dict ? [[SMNutritionalInformation alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _unit = [SMUnit withValue:(id)_unit];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = SMNutritionalInformation.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (void)setNilValueForKey:(NSString *)key
{
    id resolved = SMNutritionalInformation.properties[key];
    if (resolved) [super setValue:@(0) forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:SMNutritionalInformation.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in SMNutritionalInformation.properties) {
        id propertyName = SMNutritionalInformation.properties[jsonName];
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
