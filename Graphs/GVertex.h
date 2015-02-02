//
//  GVertex.h
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GVertex : NSObject
@property (nonatomic) CGPoint position;
@property (nonatomic) NSNumber *weight;
@property (nonatomic) NSString *name;
@property (nonatomic) UIColor *color;

+ (instancetype)vertexAtPosition:(CGPoint)position;
@end
