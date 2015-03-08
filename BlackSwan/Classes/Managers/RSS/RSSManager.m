//
//  RSSManager.m
//  BlackSwan
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import "RSSManager.h"

typedef void (^RSSCompletionBlock)(NSArray *rssItems);

@interface RSSManager() <NSXMLParserDelegate>

@property (nonatomic, copy) RSSCompletionBlock completionBlock;
@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation RSSManager
{
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    NSXMLParser *parser;
}

+ (id)sharedInstance
{
    static RSSManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new;});
    return instance;
}

-(void)dowloadRSSItems:(void (^)(NSArray *rssItems))completion
{
    self.completionBlock = completion;
    self.items = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:@"http://nshipster.com/feed.xml"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

#pragma mark - RSS Pharser Delegates

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [self.items addObject:[item copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (self.completionBlock) {
        self.completionBlock(self.items.copy);
    }
}



@end
