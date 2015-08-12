//
//  NVStudent.h
//  31.32TableEditing
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NVStudent : NSObject
@property (strong,nonatomic) NSString* firstname;
@property (strong,nonatomic) NSString* lastname;
@property (assign,nonatomic) CGFloat average;

- (instancetype)initRandomStudent;
@end
