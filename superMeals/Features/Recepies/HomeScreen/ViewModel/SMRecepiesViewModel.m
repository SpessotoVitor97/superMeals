//
//  SMRecepiesViewModel.m
//  superMeals
//
//  Created by Vitor Spessoto on 02/05/22.
//

#import <Foundation/Foundation.h>
#import "SMRecepiesViewModel.h"
#import "Service.h"

@implementation SMRecepiesViewModel : NSObject

NSArray *urlsArray = @[
    @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/46168/46168_295947.json",
    @"http://emeals-menubuilder-public.s3.amazonaws.com/v1/recipes/37767/37767_241270.json"
];

- (void)fetchRecepies {
    Service *service = [[Service alloc] init];
    
    for (id url in urlsArray) {
        [service call:url successHandler:^(NSData * _Nullable data) {
            if (data) {
                NSError *error;
                SMRecepies *recepies = [SMRecepies fromData:data error:&error];
                if (error) {
                    NSLog(@"Ops, something went spectacularly wrong while parsing data -> \n %@", error);
                    [self->_delegate onError:error];
                } else {
                    NSMutableArray *recepiesMutableArray = [[NSMutableArray alloc] initWithObjects:recepies, nil];
                    
                    if ([self->_recepiesArray count] == 0) {
                        self->_recepiesArray = recepiesMutableArray;
                    } else {
                        [self->_recepiesArray addObjectsFromArray:recepiesMutableArray];
                    }
                    
                    [self->_delegate onSuccess];
                }
            }
        } failureHandler:^(NSError * _Nullable error) {
            if (error) {
                [self->_delegate onError:error];
            }
        }];
    }
}

- (NSInteger)getTotalRecepies {
    return [_recepiesArray count];
}

@end