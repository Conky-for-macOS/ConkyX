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
    NSString * conkyPath = [[NSBundle mainBundle] pathForResource:@"conky" ofType:nil];
    
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
