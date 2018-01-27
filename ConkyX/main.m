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
    NSUserDefaults * conkyDefaults = [[NSUserDefaults alloc] init];
    
    if ([conkyDefaults valueForKey:@"isInstalled"])
    {
        NSLog(@"Must install conky first!");
        
        /*
         * show the conky installer window
         * which handles the whole installation process
         */
        NSApplicationMain(argc, argv);
 
        NSLog(@"Finished installing!");
        
        /*
         * update conky defaults file
         */
        [conkyDefaults setValue:@"YESSS!!" forKey:@"isInstalled"];
    }
    else
    {
        NSLog(@"Seems like conky is already installed!");
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
