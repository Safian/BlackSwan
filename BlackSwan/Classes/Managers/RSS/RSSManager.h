//
//  RSSManager.h
//  BlackSwan
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSManager : NSObject

+ (id)sharedInstance;
-(void)dowloadRSSItems:(void (^)(NSArray *rssItems))completion;


@end
