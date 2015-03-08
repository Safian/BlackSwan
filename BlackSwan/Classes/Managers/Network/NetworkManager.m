//
//  Network.m
//  BlackSwan
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import "NetworkManager.h"


#define catImageURL @"http://thecatapi.com/api/images/get?format=src&type=png"

@implementation NetworkManager

+ (id)sharedInstance
{
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new;});
    return instance;
}

-(void)dowloadRandomCatImageCompletion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:catImageURL]];
        //pass uikit image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion ([UIImage imageWithData:data]);
            }
        });
    });
}


@end
