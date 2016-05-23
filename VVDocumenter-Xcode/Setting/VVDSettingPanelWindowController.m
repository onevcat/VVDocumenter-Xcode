//
//  VVDSettingPanelWindowController.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-8-3.
//
//  Copyright (c) 2015 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VVDSettingPanelWindowController.h"
#import "VVDocumenterSetting.h"

@interface VVDSettingPanelWindowController ()<NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *tfTrigger;
@property (weak) IBOutlet NSButton *btnUseSpaces;
@property (weak) IBOutlet NSTextField *tfSpaceCount;
@property (weak) IBOutlet NSTextField *tfSpaceLabel;

@property (weak) IBOutlet NSStepper *stepperCount;

@property (weak) IBOutlet NSMatrix *mtxSinceOptions;
@property (weak) IBOutlet NSMatrix *mtxPrefixOptions;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithWhitespace;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithStar;
@property (weak) IBOutlet NSButtonCell *btnPrefixWithSlashes;
@property (weak) IBOutlet NSButton *btnAddSinceToComment;
@property (weak) IBOutlet NSButton *btnBriefDescription;
@property (weak) IBOutlet NSButton *btnUseHeaderDoc;
@property (weak) IBOutlet NSButton *btnBlankLinesBetweenSections;
@property (weak) IBOutlet NSButton *btnAlightArgumentComments;
@property (weak) IBOutlet NSButton *btnUseAuthorInformation;
@property (weak) IBOutlet NSButton *btnUseDateInformation;
@property (weak) IBOutlet NSTextField *tfAuthoInformation;
@property (weak) IBOutlet NSTextField *tfDateInformaitonFormat;
@property (weak) IBOutlet NSTextField *tfSinceVersion;

@end

@implementation VVDSettingPanelWindowController

- (instancetype)initWithWindow:(NSWindow *)window
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
    self.mtxSinceOptions.enabled = [[VVDocumenterSetting defaultSetting] addSinceToComments];
    [self.mtxSinceOptions selectCellAtRow:(NSInteger)[[VVDocumenterSetting defaultSetting] sinceOption] column:0];
    self.tfSinceVersion.enabled = [[VVDocumenterSetting defaultSetting] addSinceToComments];
    self.tfSinceVersion.stringValue = [[VVDocumenterSetting defaultSetting] sinceVersion];

    self.btnBriefDescription.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] briefDescription];
    self.btnUseHeaderDoc.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] useHeaderDoc];
    self.btnBlankLinesBetweenSections.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] blankLinesBetweenSections];
    self.btnAlightArgumentComments.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] alignArgumentComments];
    self.btnUseAuthorInformation.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] useAuthorInformation];
    self.tfAuthoInformation.stringValue = [[VVDocumenterSetting defaultSetting] authorInformation];
    self.btnUseDateInformation.state = (NSCellStateValue)[[VVDocumenterSetting defaultSetting] useDateInformation];
    self.tfDateInformaitonFormat.stringValue = [[VVDocumenterSetting defaultSetting] dateInformationFormat];
    
    if ([[VVDocumenterSetting defaultSetting] prefixWithStar]) {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithStar];
    } else if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithSlashes];
    } else {
        [self.mtxPrefixOptions selectCell:self.btnPrefixWithWhitespace];
    }

    // Disable the slashes prefix option for HeaderDoc comments
    if (self.btnUseHeaderDoc.state == NSOnState) {
        self.btnPrefixWithSlashes.enabled = NO;
    }

    [self updateUseSpace:self.btnUseSpaces.state];
    [self syncSpaceCount];

    self.tfTrigger.delegate = self;
    self.tfDateInformaitonFormat.delegate = self;
    self.tfAuthoInformation.delegate = self;
    self.tfSinceVersion.delegate = self;
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
    [[VVDocumenterSetting defaultSetting] setSinceVersion:@""];
    [[VVDocumenterSetting defaultSetting] setBriefDescription:NO];
    [[VVDocumenterSetting defaultSetting] setUseHeaderDoc:NO];
    [[VVDocumenterSetting defaultSetting] setBlankLinesBetweenSections:YES];
    [[VVDocumenterSetting defaultSetting] setAlignArgumentComments:YES];
    [[VVDocumenterSetting defaultSetting] setUseAuthorInformation:NO];
    [[VVDocumenterSetting defaultSetting] setAuthorInformation:VVDDefaultAuthorString];
    [[VVDocumenterSetting defaultSetting] setUseDateInformation:NO];
    [[VVDocumenterSetting defaultSetting] setDateInformationFormat:VVDDefaultDateInfomationFormat];
    
    self.btnUseSpaces.state = NSOnState;
    [self updateUseSpace:self.btnUseSpaces.state];
    self.btnPrefixWithWhitespace.state = NSOffState;
    self.btnPrefixWithStar.state = NSOnState;
    self.btnPrefixWithSlashes.state = NSOffState;
    self.btnAddSinceToComment.state = NSOffState;
    self.tfSinceVersion.enabled = NO;
    self.mtxSinceOptions.enabled = NO;
    self.btnBriefDescription.state = NSOffState;
    [self.tfTrigger setStringValue:VVDDefaultTriggerString];
    self.btnUseHeaderDoc.state = NSOffState;
    self.btnBlankLinesBetweenSections.state = NSOnState;
    self.btnAlightArgumentComments.state = NSOnState;
    self.btnUseAuthorInformation.state = NSOffState;
    self.tfAuthoInformation.stringValue = VVDDefaultAuthorString;
    self.btnUseDateInformation.state = NSOffState;
    self.tfDateInformaitonFormat.stringValue = VVDDefaultDateInfomationFormat;
    
    self.btnPrefixWithSlashes.enabled = YES;

    [self syncSpaceCount];

}

- (IBAction)mtxSinceOptionPressed:(id)sender {
    VVDSinceOption option = self.mtxSinceOptions.selectedRow;
    [[VVDocumenterSetting defaultSetting] setSinceOption:option];
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
    BOOL enableSince = self.btnAddSinceToComment.state;
    [[VVDocumenterSetting defaultSetting] setAddSinceToComments:enableSince];
    self.tfSinceVersion.enabled = enableSince;
    self.mtxSinceOptions.enabled = enableSince;
}

- (IBAction)btnBriefDescriptionPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setBriefDescription:self.btnBriefDescription.state];
}

- (IBAction)btnUseAuthorInformationPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseAuthorInformation:self.btnUseAuthorInformation.state];
}

- (IBAction)btnUseDateInformationPressed:(id)sender {
    [[VVDocumenterSetting defaultSetting] setUseDateInformation:self.btnUseDateInformation.state];
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
    if([notification object] == self.tfAuthoInformation) {
        [[VVDocumenterSetting defaultSetting] setAuthorInformation:self.tfAuthoInformation.stringValue];
    }
    if([notification object] == self.tfDateInformaitonFormat) {
        [[VVDocumenterSetting defaultSetting] setDateInformationFormat:self.tfDateInformaitonFormat.stringValue];
    }
    if ([notification object] == self.tfSinceVersion) {
        [[VVDocumenterSetting defaultSetting] setSinceVersion:self.tfSinceVersion.stringValue];
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

    if (self.btnUseHeaderDoc.state == NSOnState) {
        self.btnPrefixWithSlashes.enabled = NO;

        // If the slashes option was selected, change to the default stars
        if ([self.mtxPrefixOptions.selectedCell isEqual:self.btnPrefixWithSlashes]) {
            [self.mtxPrefixOptions selectCell:self.btnPrefixWithStar];

            // Update the settings in addition to the display
            [self.mtxPrefixOptions sendAction];
        }
    } else {
        self.btnPrefixWithSlashes.enabled = YES;
    }
}
- (IBAction)blankLinesBetweenSections:(id)sender {
    [[VVDocumenterSetting defaultSetting] setBlankLinesBetweenSections:self.btnBlankLinesBetweenSections.state];
}

- (IBAction)alignArgumentComments:(id)sender {
    [[VVDocumenterSetting defaultSetting] setAlignArgumentComments:self.btnAlightArgumentComments.state];
}

@end
