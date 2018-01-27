//
//  AppDelegate.m
//  ConkyX
//
//  Created by Nikolas Pylarinos on 23/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import "AppDelegate.h"

#import "MainWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    MainWindowController *mainWindowController = [[MainWindowController alloc] init];
    
    /*
     * start the main window
     */
    [[NSBundle mainBundle] loadNibNamed:@"MainWindow" owner:mainWindowController topLevelObjects:nil];
    
    /*
     * start the install process
     */
    [mainWindowController beginInstalling];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
