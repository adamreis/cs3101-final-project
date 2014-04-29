//
//  Note.h
//  Noted
//
//  Created by Adam Reis on 4/20/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject <NSCoding>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger index;

- (id)initWithTitle:(NSString *)title text:(NSString *)text index:(NSInteger)index path:(NSString *)path;

@end
