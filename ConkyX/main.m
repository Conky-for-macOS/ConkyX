//
//  main.m
//  ConkyX
//
//  Created by Nikolas Pylarinos on 23/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[])
{
#define CONKYX_INSTALLED_LOCK_FMT @"/Users/%@/Library/ConkyX/.installed.lck"
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    if (![fm fileExistsAtPath:[NSString stringWithFormat:CONKYX_INSTALLED_LOCK_FMT, NSUserName()]])
    {
        NSLog(@"conky: not installed");
        
        /*
         * show the conky installer window
         * which handles the whole installation process
         */
        NSApplicationMain(argc, argv);
    }
    else
    {
        NSLog(@"conky: installed");
    }
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * conkyPath = [resourcePath stringByAppendingString:@"/conky"];
    
    /*
     * create conky task object
     */
    NSTask * conky = [[NSTask alloc] init];
    [conky setLaunchPath:conkyPath];
    
    /*
     * launch conky
     */
    [conky launch];
    
    return 0;
}
