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

@property (weak) IBOutlet NSMatrix *mtxPrefixOptions;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithWhitespace;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithStar;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithSlashes;
@property (assign) IBOutlet NSButton *btnAddSinceToComment;
@property (weak) IBOutlet NSButton *btnUseHeaderDoc;
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

    self.btnAddSinceToComment.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] addSinceToComments];
    self.btnUseHeaderDoc.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] useHeaderDoc];

    if ([[VVDocumenterSetting defaultSetting] prefixWithStar]) {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithStar];
    } else if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithSlashes];
    } else {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithWhitespace];
    }
    
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
    [[VVDocumenterSetting defaultSetting] setPrefixWithSlashes:NO];
    [[VVDocumenterSetting defaultSetting] setAddSinceToComments:NO];
    [[VVDocumenterSetting defaultSetting] setUseHeaderDoc:NO];
    
    self.btnUseSpaces.state = NSOnState;
    [self updateUseSpace:self.btnUseSpaces.state];
    self.btnPrefixWithWhitespace.state = NSOffState;
    self.btnPrefixWithStar.state = NSOnState;
    self.btnPrefixWithSlashes.state = NSOffState;
    self.btnAddSinceToComment.state = NSOffState;
    [self.tfTrigger setStringValue:VVDDefaultTriggerString];
    self.btnUseHeaderDoc.state = NSOffState;
    
    [self syncSpaceCount];
    
}

- (IBAction)btnUseSpacesPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseSpaces:self.btnUseSpaces.state];
    [self updateUseSpace:self.btnUseSpaces.state];
}

- (IBAction)mtxPrefixSettingPressed:(id)sender {
    id selectedCell = self.mtxPrefixOptions.selectedCell;

    [[VVDocumenterSetting defaultSetting] setPrefixWithStar:[selectedCell isEqual:self.btnPrefixWithStar]];
    [[VVDocumenterSetting defaultSetting] setPrefixWithSlashes:[selectedCell isEqual:self.btnPrefixWithSlashes]];
}

- (IBAction)btnAddSinceToCommentsPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setAddSinceToComments:self.btnAddSinceToComment.state];
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
- (IBAction)useHeaderDoc:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseHeaderDoc:self.btnUseHeaderDoc.state];
}
@end
