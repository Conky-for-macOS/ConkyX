//
//  ViewController.m
//  ConkyX
//
//  Created by Nickolas Pylarinos on 08/07/2018.
//  Copyright © 2018 Nickolas Pylarinos. All rights reserved.
//

#import "ViewController.h"

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

- (IBAction)runCommand:(id)sender {
    
    // XXX bug exists when -c 'path with spaces'
    
    if (![sender stringValue])
        return;
    
    if ([[sender stringValue] length] == 0)
        return;
    
    NSArray *args = [[sender stringValue] componentsSeparatedByString:@" "];
    if (!args)
        return;
    
    NSTask *conky = [[NSTask alloc] init];
    conky.launchPath = CONKY_SYMLINK;
    conky.arguments = args;

    /*
     * Try to discover workingDirectory
     */
    if ([args containsObject:@"-s"])
    {
        NSUInteger i = [args indexOfObject:@"-s"];
        conky.currentDirectoryPath = [args[i] stringByDeletingLastPathComponent];
    }
    
    /*
     * All done; Launch the thing
     */
    @try {
        [conky launch];
    } @catch (NSException *exception) {
        NSLog(@"Got exception: %@", exception);
    } @finally {
        
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
            NSString *path = [url relativePath];
            
            NSTask *conky = [[NSTask alloc] init];
            conky.launchPath = CONKY_SYMLINK;
            conky.arguments = @[@"-c", path];
            conky.currentDirectoryPath = [[path stringByDeletingLastPathComponent] stringByStandardizingPath];
            
            @try {
                [conky launch];
            } @catch (NSException *exception) {
                NSLog(@"Got exception: %@", exception);
            } @finally {
                
            }
        }
    }];
}

//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//}

@end
