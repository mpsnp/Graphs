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
#import "GEdgeEditViewController.h"
#import <WEPopover/WEPopoverController.h>

@interface GDjikstraViewController () <WEPopoverControllerDelegate>
@property (nonatomic, strong) GOrientedGraph *graph;
@property (nonatomic, strong) GOrientedGraph *minimalGraph;
@property (weak, nonatomic) IBOutlet GGraphView *minimalGraphView;
@property (nonatomic) WEPopoverController *popOver;
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

- (IBAction)changing:(GGraphView *)sender
{
    GEdgeEditViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOver"];
    editor.edgeForEdit = sender.selectedEdge;
    if (editor)
    {
        self.popOver = [[WEPopoverController alloc] initWithContentViewController:editor];
        self.popOver.delegate = self;
        self.popOver.popoverContentSize = CGSizeMake(200, 50);
        [self.popOver presentPopoverFromRect:[sender rectForEdge:sender.selectedEdge] inView:self.minimalGraphView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    [self topGraphChanged:self];
    [self setMinimalGraph:[self.graph minimalPathTreeStartingFromVertex:self.graph.vertexes[0]]];
}

- (IBAction)topGraphChanged:(id)sender
{
    [self.view setNeedsDisplay];
    [self.minimalGraphView setNeedsDisplay];
}

@end
