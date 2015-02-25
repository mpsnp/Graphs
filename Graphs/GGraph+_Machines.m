//
//  GGraph+_Machines.m
//  Graphs
//
//  Created by George on 04/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph+_Machines.h"

@implementation G3MachinesVertex

+ (G3MachinesVertex *)vertexWith:(NSNumber *)a b:(NSNumber *)b c:(NSNumber *)c
{
    G3MachinesVertex *vertex = [G3MachinesVertex new];
    vertex.A = a;
    vertex.B = b;
    vertex.C = c;
    return vertex;
}

- (void)findDeltaWith:(NSArray *)a b:(NSArray *)b c:(NSArray *)c
{
    double da = [self.A doubleValue];
    double db = [self.B doubleValue];
    double dc = [self.C doubleValue];
    NSNumber *index = [self.freeIndexes anyObject];
    double minA = [b[[index unsignedIntegerValue]] doubleValue] + [c[[index unsignedIntegerValue]] doubleValue];
    double minB = [c[[index unsignedIntegerValue]] doubleValue];
    for (NSNumber *index in self.freeIndexes)
    {
        da += [a[[index unsignedIntegerValue]] doubleValue];
        db += [b[[index unsignedIntegerValue]] doubleValue];
        dc += [c[[index unsignedIntegerValue]] doubleValue];
        double newAValue = [b[[index unsignedIntegerValue]] doubleValue] + [c[[index unsignedIntegerValue]] doubleValue];
        double newBValue = [c[[index unsignedIntegerValue]] doubleValue];
        if (minA > newAValue)
        {
            minA = newAValue;
        }
        if (minB > newBValue)
        {
            minB = newBValue;
        }
    }
    da += minA;
    db += minB;
    
    self.dA = @(da);
    self.dB = @(db);
    self.dC = @(dc);
    
    double max = MAX(MAX(da, db), dc);
    self.delta = @(max);
    self.name = [NSString stringWithFormat:@"%@/%@", self.delta, self.index];
}

@end

@implementation GGraph (_Machines)

- (G3MachinesVertex *)findBest3Leaf
{
    NSArray *leafs = [self findLeafs];
    G3MachinesVertex *currentVertex = [leafs firstObject];
    for (G3MachinesVertex *vertex in leafs)
    {
        if ([currentVertex.delta doubleValue] > [vertex.delta doubleValue])
        {
            currentVertex = vertex;
        }
    }
    return currentVertex;
}

+ (GGraph *)buildGraphWithA:(NSArray *)a b:(NSArray *)b c:(NSArray *)c
{
    GGraph *result = [GGraph new];
    NSMutableSet *startIndexes = [NSMutableSet new];
    for (int i = 0; i < a.count; i++)
    {
        [startIndexes addObject:@(i)];
    }
    G3MachinesVertex *startVertex = [G3MachinesVertex vertexWith:@(0) b:@(0) c:@(0)];
    startVertex.freeIndexes = startIndexes;
    startVertex.parent = startVertex;
    [startVertex findDeltaWith:a b:b c:c];
    
    [result addVertex:startVertex];
    
    G3MachinesVertex *currentVertex = startVertex;
    
    while ([currentVertex.freeIndexes count] > 0)
    {
        for (NSNumber *index in currentVertex.freeIndexes)
        {
            NSMutableSet *newIndexes = [currentVertex.freeIndexes mutableCopy];
            [newIndexes removeObject:index];
            double A = [currentVertex.A doubleValue] + [[a objectAtIndex:[index unsignedIntegerValue]] doubleValue];
            double B = MAX([currentVertex.B doubleValue], A) + [[b objectAtIndex:[index unsignedIntegerValue]] doubleValue];
            double C = MAX([currentVertex.C doubleValue], B) + [[c objectAtIndex:[index unsignedIntegerValue]] doubleValue];
            G3MachinesVertex *newVertex = [G3MachinesVertex vertexWith:@(A) b:@(B) c:@(C)];
            newVertex.freeIndexes = newIndexes;
            newVertex.parent = currentVertex;
            newVertex.index = index;
            newVertex.position = CGPointMake((float)rand()/(float)(RAND_MAX), (float)rand()/(float)(RAND_MAX));
            [newVertex findDeltaWith:a b:b c:c];
            [result addVertex:newVertex];
            [result addEdge:[GEdge edgeWithVertex:currentVertex andVertex:newVertex]];
        }
        
        currentVertex = [result findBest3Leaf];
    }
    
    return result;
}

@end
