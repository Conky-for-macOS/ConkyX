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

-(void)beginInstalling
{
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
    
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments:@[@"InstallLibraries.sh"]];
    
    [script launch];
    [script waitUntilExit];
    
    NSLog(@"Finished installing!");
    
    /*
     * update conky defaults file
     */
    NSUserDefaults *conkyDefaults = [[NSUserDefaults alloc] init];
    
    [conkyDefaults setValue:@"1" forKey:@"isInstalled"];
}

@end
