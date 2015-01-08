//
//  GGraphView.m
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraphView.h"
#import "GGraph.h"
#import "GVertex.h"
#import "GEdge.h"
#import "UIBezierPath+Image.h"

@implementation GGraphView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.fillColor = [UIColor whiteColor];
    self.lineColor = [UIColor blackColor];
    self.lineWidth = 1;
    self.pointSize = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
//    self.grap
}

- (CGPoint)fromNormalizedCoord:(CGPoint)point
{
    double scaleX = self.bounds.size.width;
    double scaleY = self.bounds.size.height;
    
    return CGPointMake(point.x * scaleX, point.y * scaleY);
}

- (CGPoint)toNormalizedCoord:(CGPoint)point
{
    double scaleX = self.bounds.size.width;
    double scaleY = self.bounds.size.height;
    
    return CGPointMake(point.x / scaleX, point.y / scaleY);
}

- (double)doubleNorm:(CGPoint)point
{
    return point.x * point.x + point.y * point.y;
}

- (CGPoint)add:(CGPoint)p1 to:(CGPoint)p2
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

- (CGPoint)subFrom:(CGPoint)p1 p2:(CGPoint)p2
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint curPoint = [sender locationInView:self];
    CGPoint translation = [sender translationInView:self];
    CGPoint start = CGPointMake(curPoint.x - translation.x, curPoint.y - translation.y);
    
    GVertex *vertexForMove = [self.graph.vertexes firstObject];
    
    if (vertexForMove)
    {
        double minDistance = [self doubleNorm:[self subFrom:start p2:[self fromNormalizedCoord:vertexForMove.position]]];
        
        for (GVertex *vertex in self.graph.vertexes)
        {
            double distance = [self doubleNorm:[self subFrom:start p2:[self fromNormalizedCoord:vertex.position]]];
            if (distance < minDistance)
            {
                minDistance = distance;
                vertexForMove = vertex;
            }
        }
        
        vertexForMove.position = [self add:vertexForMove.position to:[self toNormalizedCoord:translation]];
    }
    [sender setTranslation:CGPointZero inView:self];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setGraph:(GGraph *)graph
{
    _graph = graph;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.graph)
    {
        for (GEdge *edge in self.graph.edges)
        {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path setLineWidth:self.lineWidth];
            [path moveToPoint:[self fromNormalizedCoord:edge.v1.position]];
            [path addLineToPoint:[self fromNormalizedCoord:edge.v2.position]];
            [edge.color ? edge.color : self.lineColor setStroke];
            [path stroke];
            CGPoint textOrigin = [self add:[self fromNormalizedCoord:edge.v1.position] to:[self fromNormalizedCoord:edge.v2.position]];
            textOrigin = CGPointMake(textOrigin.x * 0.5, textOrigin.y * 0.5);
            path = [UIBezierPath bezierPathWithArcCenter:textOrigin radius:self.pointSize * 0.8 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [path setLineWidth:self.lineWidth];
            [self.fillColor setFill];
            [path fill];
            
            NSAttributedString *weight = [[NSAttributedString alloc] initWithString:[edge.weight stringValue] attributes:@{NSFontAttributeName: [UIFont fontWithName:nil size:10], NSForegroundColorAttributeName: edge.color ? edge.color : self.lineColor}];
            CGPoint origin = CGPointMake(path.bounds.origin.x + path.bounds.size.width * 0.5 - weight.size.width * 0.5,
                                         path.bounds.origin.y + path.bounds.size.height * 0.5 - weight.size.height * 0.5);
            [weight drawAtPoint:origin];
        }
        
        for (GVertex *vertex in self.graph.vertexes)
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:[self fromNormalizedCoord:vertex.position] radius:self.pointSize startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [self.fillColor setFill];
            [path fill];
            [self.lineColor setStroke];
            [path stroke];
            NSAttributedString *name = [[NSAttributedString alloc] initWithString:vertex.name attributes:@{NSFontAttributeName: [UIFont fontWithName:nil size:14]}];
            CGPoint origin = CGPointMake(path.bounds.origin.x + path.bounds.size.width * 0.5 - name.size.width * 0.5,
                                         path.bounds.origin.y + path.bounds.size.height * 0.5 - name.size.height * 0.5);
            [name drawAtPoint:origin];
        }
    }
    else
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:20]};
        [@"No Graph Specified" drawAtPoint:CGPointMake(0, rect.size.height * 0.5) withAttributes:attributes];
    }
}

@end
