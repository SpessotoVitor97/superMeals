//
//  Service.h
//  superMeals
//
//  Created by Vitor Spessoto on 03/05/22.
//

#ifndef Service_h
#define Service_h

@interface Service : NSObject

@property (strong, nonatomic, nonnull) NSMutableURLRequest *request;
-(void)makeCall:(NSString *_Nonnull)url;

@end

#endif /* Service_h */
