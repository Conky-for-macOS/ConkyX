//
//  ViewController.m
//  ConkyX
//
//  Created by Nickolas Pylarinos on 08/07/2018.
//  Copyright © 2018 Nickolas Pylarinos. All rights reserved.
//

#import "ViewController.h"

#import "../../Manage Conky/MCFilesystem.h"

#define CONKY_SYMLINK @"/usr/local/bin/conky"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static bool firstRun = true;
    if (firstRun)
    {
        firstRun = false;
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        
        if ([args count] == 1)
            return;

        NSArray *argsWithoutPWD = [args subarrayWithRange:NSMakeRange(1, [args count] - 1)];
        
        _commandField.stringValue = [argsWithoutPWD componentsJoinedByString:@" "];
    }
}

- (IBAction)runCommand:(id)sender
{
    // XXX bug exists when -c 'path with spaces'
    
    if (![_commandField stringValue])
        return;
    
    if ([[_commandField stringValue] length] == 0)
        return;
    
    NSArray *args = [[_commandField stringValue] componentsSeparatedByString:@" "];
    if (!args)
        return;
    
    NSTask *conky = [[NSTask alloc] init];
    conky.launchPath = CONKY_SYMLINK;
    conky.arguments = args;

    /*
     * Try to discover workingDirectory
     */
    if ([args containsObject:@"-c"])
    {
        NSUInteger i = [args indexOfObject:@"-c"];
        conky.currentDirectoryPath = [args[i + 1] stringByDeletingLastPathComponent];
    }
    
    /*
     * All done; Launch the thing
     */
    @try {
        [conky launch];
    } @catch (NSException *exception) {
        NSLog(@"Got exception: %@", exception);
    }
}

- (IBAction)runScript:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    openPanel.allowsMultipleSelection = YES;
    
    [openPanel beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSModalResponse result) {
       if (result != NSModalResponseOK)
           return;
        
        NSArray *urls = [openPanel URLs];
        
        for (NSURL *url in urls)
        {
            NSString *config = [url path];
            NSString *correctedConfig = MCNormalise(config);
            NSString *currentDirectory = [config stringByDeletingLastPathComponent];
            
            NSString *cmd = [NSString stringWithFormat:@"%@ -c %@", CONKY_SYMLINK, correctedConfig];
            
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/bin/bash"];
            [task setArguments:@[@"-l",
                                 @"-c",
                                 cmd]];
            [task setCurrentDirectoryPath:currentDirectory];
            [task setEnvironment:[NSProcessInfo processInfo].environment];          /*
                                                                                     * Some conky widgets like Conky-Vision
                                                                                     * (original: https://github.com/zagortenay333/conky-Vision)
                                                                                     * use external executables thus we need to
                                                                                     * provide the basic environment for them
                                                                                     * like environment-variables.
                                                                                     */
            [task launch];
        }
    }];
}

@end
