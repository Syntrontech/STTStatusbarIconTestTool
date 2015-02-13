//
//  AppDelegate.m
//  SSTStatusBarIconTestTool
//
//  Created by Hardy on 2015/2/12.
//  Copyright (c) 2015年 Syntrontech. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *popupButton;
@property (weak) IBOutlet NSImageView *previewImage;
@property (weak) IBOutlet NSTextField *fileNameLabel;
@property (weak) IBOutlet NSTextField *imageSizeLabel;
@property (weak) IBOutlet NSMenu *menu;

@end

@implementation AppDelegate
- (void)awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.image = [NSImage imageNamed:@"default-status-icon"];
    self.statusBar.highlightMode = YES;
    self.statusBar.menu = self.menu;
    
    [self.window setLevel:NSFloatingWindowLevel];
    [self.popupButton selectItemAtIndex:0];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)chooseItemBePressed:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setAllowedFileTypes:@[@"public.image"]];
    
    if ([panel runModal] == NSModalResponseOK) {
        NSURL *fileURL = [panel URL];
        
        NSImage *newIconImage = [[NSImage alloc] initWithContentsOfURL:fileURL];
        self.statusBar.image = newIconImage;
        self.previewImage.image = newIconImage;
        self.fileNameLabel.stringValue = [[fileURL path] lastPathComponent];
        
        NSSize iconSize = [self iconImageSize:[fileURL path]];
        NSString *imageSizeString = [NSString stringWithFormat:@"Image Size: %d x %d", (int)iconSize.width, (int)iconSize.height];
        self.imageSizeLabel.stringValue = [self.imageSizeLabel.stringValue stringByAppendingString:imageSizeString];
        
        if ([[self.popupButton itemArray] count] > 1) {
            NSMenuItem *menuItem = [self.popupButton itemAtIndex:0];
            menuItem.title = [fileURL path];
        } else {
            [self.popupButton insertItemWithTitle:[fileURL path] atIndex:0];
        }
        
        [self.popupButton selectItemAtIndex:0];
    }
}

- (NSSize)iconImageSize:(NSString *)path {
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:path];
    
    NSInteger width = 0;
    NSInteger height = 0;
    
    for (NSImageRep * imageRep in imageReps) {
        if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    }
    
    return NSMakeSize(width, height);
}

- (IBAction)settingItemBePressed:(id)sender {
    [self.window makeKeyAndOrderFront:self];
}

@end
