/*
   GNUstep ProjectCenter - http://www.projectcenter.ch

   Copyright (C) 2000 Philippe C.D. Robert

   Author: Philippe C.D. Robert <phr@projectcenter.ch>

   This file is part of ProjectCenter.

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.

   $Id$
*/

#import "PCBundleLoader.h"
#import "ProjectCenter.h"

@interface PCBundleLoader (PrivateLoader)

- (void)loadAdditionalBundlesAt:(NSString *)path;

@end

@implementation PCBundleLoader (PrivateLoader)

- (void)loadAdditionalBundlesAt:(NSString *)path
{
    NSBundle *bundle;
    
    NSAssert(path,@"No valid bundle path specified!");

#ifdef DEBUG
    NSLog([NSString stringWithFormat:@"Loading bundle %@...",path]);
#endif DEBUG

    if ((bundle = [NSBundle bundleWithPath:path])) {
        [loadedBundles addObject:bundle];

#ifdef DEBUG
        NSLog([NSString stringWithFormat:@"Bundle %@ successfully loaded!",path]);
#endif DEBUG

        if (delegate && [delegate respondsToSelector:@selector(bundleLoader: didLoadBundle:)]) {
            [delegate bundleLoader:self didLoadBundle:bundle];
        }
    }
    else {
        NSRunAlertPanel(@"Attention!",@"Could not load %@!",@"OK",nil,nil,path);
    }
}

@end

@implementation PCBundleLoader

//----------------------------------------------------------------------------
// Init and free methods
//----------------------------------------------------------------------------

- (id)init
{
    if ((self = [super init])) {
        loadedBundles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [loadedBundles release];
    
    [super dealloc];
}

- (id)delegate
{
    return delegate;
}

- (void)setDelegate:(id)aDelegate
{
    delegate = aDelegate;
}

- (void)loadBundles
{
    NSEnumerator 	*enumerator;
    NSString		*bundleName;
    NSArray		*dir;
    NSString 		*path = [[NSUserDefaults standardUserDefaults] objectForKey:BundlePaths];

    if (!path || path == @"" || ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
      [NSException raise:@"PCBundleLoaderPathException" format:@"No valid bundle path specified!"];
      return;
    }
    else {
      NSLog([NSString stringWithFormat:@"Loading bundles at %@",path]);
    }

    dir = [[NSFileManager defaultManager] directoryContentsAtPath:path];
    enumerator = [dir objectEnumerator];
    while (bundleName = [enumerator nextObject]) {
        if ([[bundleName pathExtension] isEqualToString:@"bundle"]) {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",path,bundleName];
            
            [self loadAdditionalBundlesAt:fullPath];
        }
    }
}

- (NSArray *)loadedBundles
{
    return loadedBundles;
}

@end
