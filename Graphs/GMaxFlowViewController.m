//
//  GMaxFlowViewController.m
//  Graphs
//
//  Created by George on 02/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GMaxFlowViewController.h"
#import "GGraph.h"
#import "GOrientedGraph.h"
#import "GGraphView.h"
#import "GEdgeEditViewController.h"
#import <WEPopoverController.h>

@interface GMaxFlowViewController () <WEPopoverControllerDelegate>
@property (nonatomic, strong) GOrientedGraph *graph;
@property (nonatomic) WEPopoverController *popOver;
@property (nonatomic) NSMutableArray *selectedPoints;
@end

@implementation GMaxFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"8.7" ofType:@"json"]];
    self.graph = [GOrientedGraph orientedGraphWithGraph:[GOrientedGraph graphWithData:data]];
    
    GGraphView *view = (GGraphView *)self.view;
    view.graph = self.graph;
    self.selectedPoints = [NSMutableArray arrayWithObjects:self.graph.vertexes[0],self.graph.vertexes[1], nil];
    [self recalculate];
}

- (void)recalculate
{
    [(GVertex *)self.selectedPoints[0] setColor:[UIColor greenColor]];
    [(GVertex *)self.selectedPoints[1] setColor:[UIColor redColor]];
    
    [self.graph findMaxFlowFrom:self.selectedPoints[0] to:self.selectedPoints[1]];
    [self.view setNeedsDisplay];
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    [self recalculate];
}

- (IBAction)changing:(GGraphView *)sender
{
    if (sender.selectionType == GGraphSelectionEdge)
    {
        GEdgeEditViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOver"];
        editor.edgeForEdit = sender.selectedEdge;
        if (editor)
        {
            self.popOver = [[WEPopoverController alloc] initWithContentViewController:editor];
            self.popOver.delegate = self;
            self.popOver.popoverContentSize = CGSizeMake(200, 50);
            [self.popOver presentPopoverFromRect:[sender rectForEdge:sender.selectedEdge] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        
        [self.selectedPoints addObject:sender.selectedVertex];
        [(GVertex *)self.selectedPoints[0] setColor:nil];
        [self.selectedPoints removeObjectAtIndex:0];
        [self recalculate];
    }
}

@end
