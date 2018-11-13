//
//  HDLocalizeHelper.m
//  NBSmartApp
//
//  Created by Yetthapu's on 16/9/17.
//  Copyright © 2017 Hexadots. All rights reserved.
//

#import "HDLocalizeHelper.h"

// Singleton
static HDLocalizeHelper* singleLocalSystem = nil;
static dispatch_once_t once;
// my Bundle (not the main bundle!)
static NSBundle* myBundle = nil;

@implementation HDLocalizeHelper


//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
+ (HDLocalizeHelper*) sharedLocalSystem {
    // lazy instantiation
    dispatch_once(&once, ^{
        singleLocalSystem = [[HDLocalizeHelper alloc] init];
    });
    return singleLocalSystem;
}

//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
        myBundle = [NSBundle mainBundle];
    }
    return self;
}


//-------------------------------------------------------------
// translate a string
//-------------------------------------------------------------
// you can use this macro:
// LocalizedString(@"Text");
- (NSString*) localizedStringForKey:(NSString*) key {
    // this is almost exactly what is done when calling the macro NSLocalizedString(@"Text",@"comment")
    // the difference is: here we do not use the systems main bundle, but a bundle
    // we selected manually before (see "setLanguage")
    return [myBundle localizedStringForKey:key value:@"" table:nil];
}


//-------------------------------------------------------------
// set a new language
//-------------------------------------------------------------
// you can use this macro:
// LocalizationSetLanguage(@"French") or LocalizationSetLanguage(@"fr");
- (void) setLanguage:(NSString*) lang {
    
    // path to this languages bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    if (path == nil) {
        // there is no bundle for that language
        // use main bundle instead
        myBundle = [NSBundle mainBundle];
    } else {
        
        // use this bundle as my bundle from now on:
        myBundle = [NSBundle bundleWithPath:path];
        
        // to be absolutely shure (this is probably unnecessary):
        if (myBundle == nil) {
            myBundle = [NSBundle mainBundle];
        }
    }
}

- (void)resetLocalizeHelper {
    singleLocalSystem = nil;
    once = 0;
}


@end
