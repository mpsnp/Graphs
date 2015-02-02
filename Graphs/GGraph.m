//
//  GGraph.m
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph.h"

@implementation GGraph

- (NSMutableArray *)vertexes
{
    if (!_vertexes)
        _vertexes = [NSMutableArray array];
    return _vertexes;
}

- (NSMutableArray *)edges
{
    if (!_edges)
        _edges = [NSMutableArray array];
    return _edges;
}

- (void)addVertex:(GVertex *)vertex
{
    [self.vertexes addObject:vertex];
}

- (void)addEdge:(GEdge *)edge
{
    [self.edges addObject:edge];
}

- (GGraph *)spanningTreeMinimal:(BOOL)minimal
{
    GGraph *result = [GGraph new];
    result.vertexes = self.vertexes;
    
    NSArray *edges = [self.edges sortedArrayUsingComparator:^NSComparisonResult(GEdge *obj1, GEdge *obj2) {
        if (minimal)
            return [obj1.weight doubleValue] > [obj2.weight doubleValue];
        else
            return [obj1.weight doubleValue] < [obj2.weight doubleValue];
    }];
    
    NSMutableArray *vertexSets = [NSMutableArray arrayWithCapacity:[self.vertexes count]];
    
    for (id vertex in self.vertexes)
    {
        [vertexSets addObject:[NSMutableSet setWithObject:vertex]];
    }
    
    for (GEdge *edge in edges)
    {
        NSMutableSet *selectedSets = [NSMutableSet setWithCapacity:2];
        for (NSMutableSet *set in vertexSets)
        {
            if ([set containsObject:edge.v1] || [set containsObject:edge.v2])
                [selectedSets addObject:set];
        }
        if ([selectedSets count] == 2)
        {
            [result addEdge:edge];
            NSArray *sets = [selectedSets allObjects];
            NSMutableSet *firstSet = [sets objectAtIndex:0];
            NSMutableSet *secondSet = [sets objectAtIndex:1];
            [firstSet addObjectsFromArray:[secondSet allObjects]];
            [vertexSets removeObject:secondSet];
        }
    }
    
    return result;
}

+ (instancetype)graphWithData:(NSData *)data
{
    GGraph *graph = [self new];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (dict)
    {
        NSArray *vertexes = dict[@"vertexes"];
        for (NSDictionary *vertexDict in vertexes)
        {
            double x = [vertexDict[@"position"][@"x"] doubleValue];
            double y = [vertexDict[@"position"][@"y"] doubleValue];
            GVertex *vertex = [GVertex vertexAtPosition:CGPointMake(x, y)];
            vertex.weight = vertexDict[@"weight"];
            vertex.name = vertexDict[@"name"];
            [graph addVertex:vertex];
        }
        
        NSArray *edges = dict[@"edges"];
        for (NSDictionary *edgeDict in edges)
        {
            
            GEdge *edge = [GEdge edgeWithVertex:graph.vertexes[[edgeDict[@"v1"] integerValue] - 1] andVertex:graph.vertexes[[edgeDict[@"v2"] integerValue] - 1]];
            edge.weight = edgeDict[@"weight"];
            [graph addEdge:edge];
        }
    }
    
    return graph;
}

@end
