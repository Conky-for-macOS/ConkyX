//
//  MainWindowController.m
//  ConkyX
//
//  Created by Nikolas Pylarinos on 27/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import "MainWindowController.h"

#define HOMEBREW_PATH "/usr/local/bin/brew"
#define XQUARTZ_PATH  "/usr/X11"

@implementation MainWindowController

@synthesize window = _window;
@synthesize logField = _logField;
@synthesize progressIndicator = _progressIndicator;

- (void)receivedData:(NSNotification*)notif
{
    NSFileHandle *fh = [notif object];
    NSData *data = [fh availableData];
    if (data.length > 0) { // if data is found, re-register for more data (and print)
        [fh waitForDataInBackgroundAndNotify];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            _logField.stringValue = [_logField.stringValue stringByAppendingString:str];
        });
    }
};

- (void)beginInstalling
{
    [_progressIndicator startAnimation:nil];
    
    /*
     * detect if Homebrew is installed
     */
    if (access(HOMEBREW_PATH, F_OK) != 0)
    {
        NSAlert *hbalert = [[NSAlert alloc] init];
        [hbalert setMessageText:@"Homebrew missing"];
        [hbalert setInformativeText:@"Install Homebrew first using this link: https://brew.sh/\nOnce you install click OK to continue"];
        [hbalert runModal];
    }
    
    /*
     * detect if XQuartz is installed
     */
    if (access(XQUARTZ_PATH, F_OK) != 0)
    {
        NSAlert *xqalert = [[NSAlert alloc] init];
        [xqalert setMessageText:@"XQuartz is missing"];
        [xqalert setInformativeText:@"Install XQuartz first using this link: https://www.xquartz.org/\nOnce you install click OK to continue"];
        [xqalert runModal];
    }
    
    /*
     * setup the installer script task
     */
    NSPipe *outputPipe = [[NSPipe alloc] init];
    NSPipe *errorPipe = [[NSPipe alloc] init];
    
    NSString *scriptPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/InstallLibraries.sh"];
    
    NSTask *script = [[NSTask alloc] init];
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments:@[scriptPath]];
    [script setStandardOutput:outputPipe];
    [script setStandardError:errorPipe];
    
    NSFileHandle *outputHandle = [outputPipe fileHandleForReading],
                 *errorHandle = [errorPipe fileHandleForReading];
    
    [outputHandle waitForDataInBackgroundAndNotify];
    [errorHandle waitForDataInBackgroundAndNotify];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData:) name:NSFileHandleDataAvailableNotification object:outputHandle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData:) name:NSFileHandleDataAvailableNotification object:errorHandle];
    
    [script setTerminationHandler:^(NSTask *task) {
        /*
         * update conky defaults file
         */
        NSUserDefaults *conkyDefaults = [[NSUserDefaults alloc] init];
        [conkyDefaults setValue:@"1" forKey:@"isInstalled"];
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
           [_progressIndicator stopAnimation:nil];
           
           NSAlert *alert = [[NSAlert alloc] init];
           [alert setMessageText:@"ConkyX Finished Installing"];
           [alert setInformativeText:@"Press OK to restart conky"];
           [alert beginSheetModalForWindow:_window completionHandler:^(NSModalResponse returnCode)
            {
                /*
                 * start the configuration panel
                 * It provides functionality that will be incorporated to ManageConky.app later...
                 */
                //MainWindowController *mainWindowController = [[MainWindowController alloc] init];
                //[[NSBundle mainBundle] loadNibNamed:@"ConfigureConky" owner:mainWindowController topLevelObjects:nil];
                
                /*
                 * restart ConkyX
                 */
                NSString *path = [[NSBundle mainBundle] bundlePath];
                NSLog(@"%@", path);
                //[[NSWorkspace sharedWorkspace] launchApplication:path];
                //[NSApp terminate:nil];
            }];
        });
    }];
    
    /*
     * run the installer script
     */
    [script launch];
}

@end
