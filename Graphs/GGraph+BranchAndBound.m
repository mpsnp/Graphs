//
//  GGraph+BranchAndBound.m
//  Graphs
//
//  Created by George on 02/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph+BranchAndBound.h"
#import "GOrientedGraph.h"

@implementation GTeta

+ (GTeta *)tetaWithI:(NSUInteger)i j:(NSUInteger)j andValue:(double)value
{
    GTeta *teta = [GTeta new];
    teta.i = i;
    teta.j = j;
    teta.value = value;
    return teta;
}

@end

@implementation GPayload

- (instancetype)init
{
    self = [super init];
    self.ignoredI = [NSMutableArray array];
    self.ignoredJ = [NSMutableArray array];
    return self;
}

+ (GPayload *)payloadWithGraph:(GGraph *)graph
{
    GPayload *result = [GPayload new];
    
    BOOL bidir = [graph isMemberOfClass:[GGraph class]];
    
    result.c = [NSMutableArray arrayWithCapacity:[graph.vertexes count]];
    for (int i = 0; i < [graph.vertexes count]; i++)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[graph.vertexes count]];
        for (int i = 0; i < [graph.vertexes count]; i++)
        {
            [array addObject:[NSNumber numberWithDouble:INFINITY]];
        }
        [result.c addObject:array];
    }
    
    for (GEdge *edge in graph.edges)
    {
        NSUInteger i = [graph.vertexes indexOfObject:edge.v1];
        NSUInteger j = [graph.vertexes indexOfObject:edge.v2];
        [[result.c objectAtIndex:i] setObject:edge.weight atIndex:j];
        if (bidir)
        {
            [[result.c objectAtIndex:j] setObject:edge.weight atIndex:i];
        }
    }
    
    [result calculate];
    
    result.value = [result sum];
    
    return result;
}

+ (GPayload *)payloadWithPayload:(GPayload *)payload
{
    GPayload *result = [GPayload new];
    
    result.c = [NSMutableArray arrayWithCapacity:[payload.c count]];
    for (NSMutableArray *pArray in payload.c)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[payload.c count]];
        for (NSNumber *num in pArray)
        {
            [array addObject:[num copy]];
        }
        [result.c addObject:array];
    }
    
    result.ignoredI = [NSMutableArray arrayWithArray:payload.ignoredI];
    result.ignoredJ = [NSMutableArray arrayWithArray:payload.ignoredJ];
    
    return result;
}

- (BOOL)canBranch
{
    return ([self.c count] - [self.ignoredI count]) > 2;
}

- (GPayload *)leftPayload
{
    GPayload *result = [GPayload payloadWithPayload:self];
    
    [result.ignoredI addObject:[NSNumber numberWithUnsignedInteger:self.bestTeta.i]];
    [result.ignoredJ addObject:[NSNumber numberWithUnsignedInteger:self.bestTeta.j]];
    result.c[self.bestTeta.j][self.bestTeta.i] = [NSNumber numberWithDouble:INFINITY];
    
    [result calculate];
    
    result.value = self.value + [result sum];
    
    return result;
}

- (GTeta *)tetaAtI:(NSUInteger)i andJ:(NSUInteger)j
{
    NSUInteger n = [self.c count];
    double a = -1;
    double b = -1;
    for (int jj = 0; jj < n; jj++)
    {
        if (![self.ignoredJ containsObject:[NSNumber numberWithInt:jj]] && j != jj)
        {
            if (a == -1)
            {
                a = [self.c[i][jj] doubleValue];
            }
            else
            {
                a = MIN(a, [self.c[i][jj] doubleValue]);
            }
        }
    }
    for (int ii = 0; ii < n; ii++)
    {
        if (![self.ignoredI containsObject:[NSNumber numberWithInt:ii]] && i != ii)
        {
            if (b == -1)
            {
                b = [self.c[ii][j] doubleValue];
            }
            else
            {
                b = MIN(a, [self.c[ii][j] doubleValue]);
            }
        }
    }
    return [GTeta tetaWithI:i j:j andValue:a + b];
}

- (void)calculate
{
    NSUInteger n = [self.c count];
    self.hi = [NSMutableArray arrayWithCapacity:n];
    self.hj = [NSMutableArray arrayWithCapacity:n];
    
    for (int i = 0; i < n; i++)
    {
        [self.hi addObject:@0];
        [self.hj addObject:@0];
    }
    
    // Приводим
    for (int i = 0; i < n; i++)
    {
        if (![self.ignoredI containsObject:[NSNumber numberWithInt:i]])
        {
            double min = [self.c[i][0] doubleValue];
            for (int j = 0; j < n; j++)
            {
                if (![self.ignoredJ containsObject:[NSNumber numberWithInt:j]])
                {
                    min = MIN(min, [self.c[i][j] doubleValue]);
                }
            }
            if (min != min || min == INFINITY)
            {
                min = 0;
            }
            self.hi[i] = [NSNumber numberWithDouble:min];
            for (int j = 0; j < n; j++)
            {
                if (![self.ignoredJ containsObject:[NSNumber numberWithInt:j]])
                {
                    self.c[i][j] = [NSNumber numberWithDouble:[self.c[i][j] doubleValue] - min];
                }
            }
        }
    }
    
    for (int j = 0; j < n; j++)
    {
        if (![self.ignoredJ containsObject:[NSNumber numberWithInt:j]])
        {
            double min = [self.c[0][j] doubleValue];
            for (int i = 0; i < n; i++)
            {
                if (![self.ignoredI containsObject:[NSNumber numberWithInt:i]])
                {
                    min = MIN(min, [self.c[i][j] doubleValue]);
                }
            }
            if (min != min || min == INFINITY)
            {
                min = 0;
            }
            self.hj[j] = [NSNumber numberWithDouble:min];
            for (int i = 0; i < n; i++)
            {
                if (![self.ignoredI containsObject:[NSNumber numberWithInt:i]])
                {
                    self.c[i][j] = [NSNumber numberWithDouble:[self.c[i][j] doubleValue] - min];
                }
            }
        }
    }
    
    //Считаем теты
    self.tetas = [NSMutableArray array];
    for (int i = 0; i < n; i++)
    {
        if (![self.ignoredI containsObject:[NSNumber numberWithInt:i]])
        {
            for (int j = 0; j < n; j++)
            {
                if (![self.ignoredJ containsObject:[NSNumber numberWithInt:j]])
                {
                    if ([self.c[i][j] isEqualToNumber:@0])
                    {
                        [self.tetas addObject:[self tetaAtI:i andJ:j]];
                    }
                }
            }
        }
    }
    self.bestTeta = [[self tetas] firstObject];
    for (GTeta *teta in self.tetas)
    {
        if (self.bestTeta.value < teta.value)
        {
            self.bestTeta = teta;
        }
    }
}

- (double)sum
{
    double result = 0;
    
    for (NSNumber *num in self.hi)
    {
        result += [num doubleValue];
    }
    for (NSNumber *num in self.hj)
    {
        result += [num doubleValue];
    }
    
    return result;
}

- (GPayload *)rightPayload
{
    GPayload *result = [GPayload payloadWithPayload:self];
    
    result.c[self.bestTeta.i][self.bestTeta.j] = [NSNumber numberWithDouble:INFINITY];
    
    result.value = self.value + self.bestTeta.value;
    
    [result calculate];
    
    return result;
}

- (GVertexPayloaded *)makeVertexPayloaded
{
    GVertexPayloaded *result = [GVertexPayloaded new];
    
    result.payload = self;
    
    result.name = [NSString stringWithFormat:@"(%lu,%lu)=%g", self.bestTeta.i, self.bestTeta.j, self.bestTeta.value];
    
    return result;
}

@end

@implementation GGraph (BranchAndBound)

- (GVertexPayloaded *)findBestLeaf
{
    NSArray *leafs = [self findLeafs];
    GVertexPayloaded *result = [leafs firstObject];
    
    for (GVertexPayloaded *leaf in leafs)
    {
        if ([(GPayload *)leaf.payload value] < [(GPayload *)result.payload value])
        {
            result = leaf;
        }
    }
    
    return result;
}

- (GGraph *)branchAndBoud
{
    GGraph *result = [GGraph new];
    result.vertexes = self.vertexes;
    GOrientedGraph *tree = [GOrientedGraph new];
    result.info = tree;
    
    BOOL bidir = [self isMemberOfClass:[GGraph class]];
    
    [tree addVertex:[[GPayload payloadWithGraph:self] makeVertexPayloaded]];
    
    GVertexPayloaded *bestLeaf = [tree findBestLeaf];
    while ([[bestLeaf payload] canBranch])
    {
        GPayload *leftPayload = [(GPayload *)[bestLeaf payload] leftPayload];
        GPayload *rightPayload = [(GPayload *)[bestLeaf payload] rightPayload];
        
        GVertexPayloaded *leftVertex = [leftPayload makeVertexPayloaded];
        leftVertex.position = CGPointMake(rand() % 10 / 10.0, rand() % 10 / 10.0);
        GEdge *leftEdge = [GEdge edgeWithVertex:bestLeaf andVertex:leftVertex];
        leftEdge.payload = leftPayload.bestTeta;
//        leftEdge.flow = [NSNumber numberWithUnsignedInteger:leftPayload.bestTeta.i];
        leftEdge.weight = [NSNumber numberWithUnsignedInteger:leftPayload.bestTeta.j];
        
        GVertexPayloaded *rightVertex = [rightPayload makeVertexPayloaded];
        rightVertex.position = CGPointMake(rand() % 10 / 10.0, rand() % 10 / 10.0);
        GEdge *rightEdge = [GEdge edgeWithVertex:bestLeaf andVertex:rightVertex];
//        rightEdge.flow = [NSNumber numberWithUnsignedInteger:-rightPayload.bestTeta.i];
        rightEdge.weight = [NSNumber numberWithUnsignedInteger:rightPayload.bestTeta.j];
        
        [tree addVertex:leftVertex];
        [tree addVertex:rightVertex];
        [tree addEdge:leftEdge];
        [tree addEdge:rightEdge];
        
        bestLeaf = [tree findBestLeaf];
    }
    
    
    
    while (bestLeaf != [tree.vertexes firstObject])
    {
        for (GEdge *edge in tree.edges)
        {
            if (edge.v2 == bestLeaf)
            {
                GTeta *payload = edge.payload;
                
                for (GEdge *trueEdge in self.edges)
                {
                    BOOL ourEdge = trueEdge.v1 == self.vertexes[payload.i] && trueEdge.v2 == self.vertexes[payload.j];
                    
                    if (bidir)
                    {
                        ourEdge |= trueEdge.v1 == self.vertexes[payload.j] && trueEdge.v2 == self.vertexes[payload.i];
                    }
                    
                    if (ourEdge)
                    {
                        [result addEdge:trueEdge];
                    }
                }
                bestLeaf = (id)edge.v1;
                break;
            }
        }
    }
    
    return result;
}

@end
