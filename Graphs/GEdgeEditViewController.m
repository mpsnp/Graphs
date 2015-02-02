//
//  GEdgeEditViewController.m
//  Graphs
//
//  Created by George on 01/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GEdgeEditViewController.h"
#import "GEdge.h"
#import <WEPopoverController.h>

@interface GEdgeEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@end

@implementation GEdgeEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.edgeForEdit)
    {
        self.weightField.text = [self.edgeForEdit.weight stringValue];
    }
}
- (IBAction)symbolEntered:(UITextField *)sender
{
    self.edgeForEdit.weight = [NSNumber numberWithDouble:[self.weightField.text doubleValue]];
}

@end
