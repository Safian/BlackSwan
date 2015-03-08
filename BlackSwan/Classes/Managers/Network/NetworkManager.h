//
//  Network.h
//  BlackSwan
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkManager : NSObject

+ (id)sharedInstance;
-(void)dowloadRandomCatImageCompletion:(void (^)(UIImage *image))completion;

@end
