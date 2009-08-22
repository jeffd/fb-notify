//
//  PreferencesWindow.m
//  FBDesktopNotifications
//
//  Created by Lee Byron on 8/20/09.
//  Copyright 2009 Facebook. All rights reserved.
//

#import "PreferencesWindow.h"
#import "ApplicationController.h"
#import "StatusKeyShortcut.h"
#import "LoginItemManager.h"
#import "BubbleDimensions.h"


@implementation PreferencesWindow

static PreferencesWindow* currentWindow;

+(void) show
{
  if (currentWindow != nil) {
    [NSApp activateIgnoringOtherApps:YES];
    [[currentWindow window] makeKeyAndOrderFront:nil];
  } else {
    currentWindow = [[PreferencesWindow alloc] init];
  }
}

-(id) init
{
  self = [super initWithWindowNibName:@"preferences"];
  if (self) {
    // Force the window to be loaded
    [[self window] center];
  }
  
  return self;
}

-(void) dealloc
{
  currentWindow = nil;
  [super dealloc];
}

- (void)windowDidLoad
{
  // Version
  NSString* v = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  [version setStringValue:[NSString stringWithFormat:@"Version %@", v]];

  // Start at Login
  [startAtLogin setState:[[LoginItemManager manager] isLoginItem]];

  // Status Update Key Shortcut
  KeyCombo hotkey;
  hotkey.code = [[StatusKeyShortcut instance] keyCode];
  if (hotkey.code) {
    hotkey.flags = [[StatusKeyShortcut instance] keyFlags];
    [statusKeyShortcut setKeyCombo:hotkey];
  }

  // Notification Duration
  [notificationDuration setIntegerValue:[[NSUserDefaults standardUserDefaults] integerForKey:kDisplayTimeKey]];

  // Load window to front
  [NSApp activateIgnoringOtherApps:YES];
  [[self window] makeKeyAndOrderFront:self];
}

- (void)shortcutRecorder:(SRRecorderControl*)recorder keyComboDidChange:(KeyCombo)hotkey
{
  [[StatusKeyShortcut instance] registerKeyShortcutWithCode:hotkey.code flags:hotkey.flags];
}

- (IBAction) startAtLoginChanged:(id) sender
{
  [[LoginItemManager manager] setIsLoginItem:([sender state] == NSOnState)];
}

- (IBAction) notificationDurationChanged:(id) sender
{
  [[NSUserDefaults standardUserDefaults] setInteger:[sender integerValue] forKey:kDisplayTimeKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end