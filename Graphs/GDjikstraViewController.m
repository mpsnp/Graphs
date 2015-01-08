//
//  GDjikstraViewController.m
//  Graphs
//
//  Created by George on 09/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GDjikstraViewController.h"
#import "GOrientedGraph.h"
#import "GGraphView.h"

@interface GDjikstraViewController ()
@property (nonatomic, strong) GOrientedGraph *graph;
@property (nonatomic, strong) GOrientedGraph *minimalGraph;
@property (weak, nonatomic) IBOutlet GGraphView *minimalGraphView;
@end

@implementation GDjikstraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"8.7" ofType:@"json"]];
    self.graph = [GOrientedGraph orientedGraphWithGraph:[GOrientedGraph graphWithData:data]];
    
    GGraphView *view = (GGraphView *)self.view;
    view.graph = self.graph;
    self.minimalGraph = [self.graph minimalPathTreeStartingFromVertex:self.graph.vertexes[0]];
}

- (void)setMinimalGraph:(GOrientedGraph *)minimalGraph
{
    _minimalGraph = minimalGraph;
    self.minimalGraphView.graph = _minimalGraph;
}

- (IBAction)topGraphChanged:(id)sender
{
    [self.view setNeedsDisplay];
}

@end
