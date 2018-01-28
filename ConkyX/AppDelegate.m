//
//  AppDelegate.m
//  ConkyX
//
//  Created by Nikolas Pylarinos on 23/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import "AppDelegate.h"

#import "PFMoveApplication.h"
#import "MainWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    /*
     * check if running from /Applications
     * If not, use show dialog to choose either to "Move" or to "Quit"
     * ConkyX will later rely heavily in running from /Applications thus
     * we have to force ourselves into ...
     */
    CXForciblyMoveToApplicationsFolder();
}

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
