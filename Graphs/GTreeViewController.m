//
//  GTreeViewController.m
//  Graphs
//
//  Created by George on 02/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GTreeViewController.h"
#import "GGraphView.h"

@implementation GTreeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [(GGraphView *)self.view setGraph:self.graph];
}

@end
