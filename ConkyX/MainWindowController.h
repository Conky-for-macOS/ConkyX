//
//  MainWindowController.h
//  ConkyX
//
//  Created by Nikolas Pylarinos on 27/01/2018.
//  Copyright © 2018 Nikolas Pylarinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSObject

@property (strong) IBOutlet NSPanel *window;
@property (weak) IBOutlet NSTextField *logField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

- (void)beginInstalling;

@end
