//
//  MainWindowController.m
//  ConkyX
//
//  Created by Nikolas Pylarinos on 27/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import "MainWindowController.h"

#define HOMEBREW_PATH "/usr/local/bin/brew"

@implementation MainWindowController

@synthesize window = _window;
@synthesize progressIndicator = _progressIndicator;

-(void)beginInstalling
{
    [_progressIndicator startAnimation:nil];
    
    /*
     * detect if Homebrew is installed
     */
    if (access(HOMEBREW_PATH, F_OK) != 0)
    {
        NSLog(@"You must install Homebrew first!");
    }
    
    /*
     * run the installer script
     */
    NSTask *script = [[NSTask alloc] init];
    
    NSString *scriptPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/InstallLibraries.sh"];
    
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments:@[scriptPath]];
    
    [script launch];
    [script waitUntilExit];
    
    /*
     * update conky defaults file
     */
    NSUserDefaults *conkyDefaults = [[NSUserDefaults alloc] init];
    [conkyDefaults setValue:@"1" forKey:@"isInstalled"];
    
    NSLog(@"Finished installing!");
    [_progressIndicator stopAnimation:nil];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"ConkyX Finished Installing"];
    [alert setInformativeText:@"Press OK to restart conky"];
    [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode)
    {
        /*
         * restart ConkyX
         */
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSLog(@"%@", path);
        [[NSWorkspace sharedWorkspace] launchApplication:path];
        [NSApp terminate:nil];
    }];
}

@end
