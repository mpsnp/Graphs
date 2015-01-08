//
//  GVertex.m
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GVertex.h"

@implementation GVertex

+ (instancetype)vertexAtPosition:(CGPoint)position
{
    GVertex *vertex = [[self alloc] init];
    vertex.position = position;
    return vertex;
}

@end
