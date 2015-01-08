//
//  GEdge.m
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GEdge.h"

@implementation GEdge

+ (instancetype)edgeWithVertex:(GVertex *)v1 andVertex:(GVertex *)v2
{
    GEdge *edge = [GEdge new];
    edge.v1 = v1;
    edge.v2 = v2;
    return edge;
}

- (id)copy
{
    GEdge *newEdge = [GEdge edgeWithVertex:self.v1 andVertex:self.v2];
    newEdge.weight = self.weight;
    newEdge.color = self.color;
    return newEdge;
}

@end
