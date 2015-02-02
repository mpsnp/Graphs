//
//  GOrientedGraph.m
//  Graphs
//
//  Created by George on 09/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GOrientedGraph.h"

@implementation GOrientedGraph

+ (GOrientedGraph *)orientedGraphWithGraph:(GGraph *)graph
{
    GOrientedGraph *oGraph = [GOrientedGraph new];
    oGraph.vertexes = graph.vertexes;
    oGraph.edges = graph.edges;
    return oGraph;
}

- (GOrientedGraph *)minimalPathTreeStartingFromVertex:(GVertex *)start
{
    GOrientedGraph *graph = [GOrientedGraph new];
    graph.vertexes = self.vertexes;
    
    for (GVertex *vertex in graph.vertexes)
    {
        vertex.weight = nil;
    }
    start.weight = @0;
    
    NSMutableArray *vertexQueue = [NSMutableArray arrayWithObject:start];
    
    while ([vertexQueue count] > 0)
    {
        GVertex *nextVertex = [vertexQueue firstObject];
        [vertexQueue removeObjectAtIndex:0];
        
        for (GEdge *edge in self.edges)
        {
            if (edge.v1 == nextVertex)
            {
                if (!edge.v2.weight || [edge.v2.weight doubleValue] > [edge.v1.weight doubleValue] + [edge.weight doubleValue])
                {
                    edge.v2.weight = [NSNumber numberWithDouble:[edge.v1.weight doubleValue] + [edge.weight doubleValue]];
                    [vertexQueue addObject:edge.v2];
                }
            }
        }
    }
    
    for (GEdge *edge in self.edges)
    {
        if ([edge.v2.weight doubleValue] == [edge.weight doubleValue] + [edge.v1.weight doubleValue])
        {
            [graph addEdge:edge];
        }
    }
    
    return graph;
}

- (NSArray *)findIncreasingPathFrom:(GVertex *)s to:(GVertex *)t
{
    GOrientedGraph *tree = [GOrientedGraph new];
    tree.vertexes = self.vertexes;
    
    NSMutableSet *visited = [NSMutableSet setWithObject:s];
    NSMutableSet *notVisited = [NSMutableSet setWithArray:self.vertexes];
    [notVisited removeObject:s];
    
    NSMutableArray *result = [NSMutableArray new];
    
    GVertex *current = s;
    
    while ([notVisited count] > 0 && current != t)
    {
        GEdge *newEdge = nil;
        for (GEdge *edge in self.edges)
        {
            GVertex *neighbor = [edge neighborVertex:current];
            if (neighbor && [edge flowDifferenceFromVertex:current] > 0 && [notVisited containsObject:neighbor])
            {
                [visited addObject:neighbor];
                [notVisited removeObject:neighbor];
                newEdge = edge;
                [result addObject:edge];
                break;
            }
        }
        if (newEdge)
            current = [newEdge neighborVertex:current];
        else
        {
            if ([result count] == 0)
                break;
            newEdge = [result lastObject];
            current = [newEdge neighborVertex:current];
            [result removeLastObject];
        }
    }
    
    if (current != t)
        [result removeAllObjects];
    
    return result;
}

- (NSNumber *)findMaxIncreaseOfPath:(NSArray *)path withStart:(GVertex *)s
{
    double result = INFINITY;
    
    GVertex *current = s;
    
    for (GEdge *edge in path)
    {
        if (result > [edge flowDifferenceFromVertex:current])
        {
            result = [edge flowDifferenceFromVertex:current];
        }
        current = [edge neighborVertex:current];
    }
    
    return [NSNumber numberWithDouble:result];
}

- (void)findMaxFlowFrom:(GVertex *)s to:(GVertex *)t
{
    for (GEdge *edge in self.edges)
    {
        edge.flow = nil;
    }
    
    NSArray *increasingPath = [self findIncreasingPathFrom:s to:t];
    while ([increasingPath count] > 0)
    {
        NSNumber *dIncrease = [self findMaxIncreaseOfPath:increasingPath withStart:s];
        GVertex *currentVertex = s;
        for (GEdge *edge in increasingPath)
        {
            [edge addFlow:dIncrease fromVertex:currentVertex];
            currentVertex = [edge neighborVertex:currentVertex];
        }
        increasingPath = [self findIncreasingPathFrom:s to:t];
    }
}

- (NSArray *)floyd
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < [self.vertexes count]; i++)
    {
        [result addObject:[NSMutableArray array]];
        for (int j = 0; j < [self.vertexes count]; j++)
        {
            result[i][j] = @100000;
        }
    }
    
    for (GEdge *edge in self.edges)
    {
        result[[self.vertexes indexOfObject:edge.v1]][[self.vertexes indexOfObject:edge.v2]] = edge.weight;
    }
    
    for (int i = 0; i < [self.vertexes count]; i++)
    {
        for (int j = 0; j < [self.vertexes count]; j++)
        {
            for (int k = 0; k < [self.vertexes count]; k++)
            {
                result[i][j] = [NSNumber numberWithDouble:MIN([result[i][j] doubleValue], [result[i][k] doubleValue] + [result[k][j] doubleValue])];
            }
        }
    }
    
    return result;
}

@end

