//
//  Service.h
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#ifndef Service_h
#define Service_h

#import "SMRecepies.h"

@interface Service : NSObject

@property (strong, nonatomic, nonnull) NSMutableURLRequest *request;

- (void)call:(NSString *_Nonnull)url successHandler:(void (^_Nonnull)(NSData * _Nullable data))successHandler failureHandler:(void (^_Nonnull)(NSError * _Nullable error))failureHandler;

@end

#endif /* Service_h */
