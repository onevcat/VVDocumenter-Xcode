//
//  VVDSettingPanelWindowController.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-8-3.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDSettingPanelWindowController.h"
#import "VVDocumenterSetting.h"

@interface VVDSettingPanelWindowController ()<NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *tfTrigger;
@property (weak) IBOutlet NSButton *btnUseSpaces;
@property (weak) IBOutlet NSTextField *tfSpaceCount;
@property (weak) IBOutlet NSTextField *tfSpaceLabel;

@property (weak) IBOutlet NSStepper *stepperCount;

@property (weak) IBOutlet NSButton *btnPrefixWithStar;

@end

@implementation VVDSettingPanelWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.tfTrigger setStringValue:[[VVDocumenterSetting defaultSetting] triggerString]];
    self.btnUseSpaces.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] useSpaces];
    
    self.btnPrefixWithStar.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] prefixWithStar];
    
    [self updateUseSpace:self.btnUseSpaces.state];
    [self syncSpaceCount];
    
    self.tfTrigger.delegate = self;
}

- (IBAction)stepperPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setSpaceCount:self.stepperCount.integerValue];
    [self syncSpaceCount];
}

- (IBAction)btnResetPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseSpaces:YES];
    [[VVDocumenterSetting defaultSetting] setTriggerString:VVDDefaultTriggerString];
    [[VVDocumenterSetting defaultSetting] setSpaceCount:2];
    [[VVDocumenterSetting defaultSetting] setPrefixWithStar:YES];
    
    self.btnUseSpaces.state = NSOnState;
    [self updateUseSpace:self.btnUseSpaces.state];
    self.btnPrefixWithStar.state = NSOnState;
    [self.tfTrigger setStringValue:VVDDefaultTriggerString];
    
    [self syncSpaceCount];
    
}

- (IBAction)btnUseSpacesPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseSpaces:self.btnUseSpaces.state];
    [self updateUseSpace:self.btnUseSpaces.state];
}

- (IBAction)btnPrefixWithStarPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setPrefixWithStar:self.btnPrefixWithStar.state];
}

-(void) syncSpaceCount
{
    NSInteger spaceCount = [[VVDocumenterSetting defaultSetting] spaceCount];
    [self.tfSpaceCount setIntegerValue:spaceCount];
    [self.stepperCount setIntegerValue:spaceCount];
}

-(void) updateUseSpace:(BOOL)useSpace
{
    [self.tfSpaceCount setEnabled:useSpace];
    [self.stepperCount setEnabled:useSpace];
    self.tfSpaceLabel.textColor = useSpace ? [NSColor blackColor] : [NSColor grayColor];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    if([notification object] == self.tfTrigger) {
        [[VVDocumenterSetting defaultSetting] setTriggerString:self.tfTrigger.stringValue];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (control == self.tfTrigger) {
        if (self.tfTrigger.stringValue.length == 0) {
            [self.tfTrigger setStringValue:VVDDefaultTriggerString];
        }
    }
    return YES;
}

@end
