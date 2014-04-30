//
//  Note.m
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import "Note.h"

@implementation Note

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeInteger:self.index forKey:@"index"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *title = [aDecoder decodeObjectForKey:@"title"];
    NSString *text = [aDecoder decodeObjectForKey:@"text"];
    NSString *uuid = [aDecoder decodeObjectForKey:@"uuid"];
    NSInteger index = [aDecoder decodeIntegerForKey:@"index"];
    
    return [self initWithTitle:title text:text index:index uuid:uuid];
    
}

- (id)initWithTitle:(NSString *)title text:(NSString *)text index:(NSInteger)index uuid:(NSString *)uuid
{
    self = [super init];
    self.title = title;
    self.text = text;
    self.index = index;
    self.uuid = uuid;
    
    return self;
}



@end
