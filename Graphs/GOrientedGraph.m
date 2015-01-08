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
            [graph addEdge:[edge copy]];
        }
    }
    
    return graph;
}

@end
