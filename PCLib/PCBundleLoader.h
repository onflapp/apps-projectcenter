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

/*
 Descriotion:

 PCBundleLoader loads all PC bundles from all the paths that are stored in the
 defaults under the key BundlePaths.

 */
#import <AppKit/AppKit.h>

#import "PreferenceController.h"
#import "ProjectEditor.h"
#import "ProjectDebugger.h"

@interface PCBundleLoader : NSObject
{
    id 			delegate; // The PCAppController!

    NSMutableArray	*loadedBundles;
}

//----------------------------------------------------------------------------
// Init and free methods
//----------------------------------------------------------------------------

- (id)init;
- (void)dealloc;

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

- (void)loadBundles;
// Load all bundles found in the BundlePaths

- (NSArray *)loadedBundles;
    // Returns all loaded ProjectCenter bundles.

//----------------------------------------------------------------------------
// BundleLoader 
//----------------------------------------------------------------------------

- (BOOL)registerProjectSubmenu:(NSMenu *)menu;
- (BOOL)registerFileSubmenu:(NSMenu *)menu;
- (BOOL)registerToolsSubmenu:(NSMenu *)menu;
- (BOOL)registerPrefController:(id<PreferenceController>)prefs;
- (BOOL)registerEditor:(id<ProjectEditor>)anEditor;
- (BOOL)registerDebugger:(id<ProjectDebugger>)aDebugger;

@end

@interface NSObject (BundleLoaderDelegates)

- (void)bundleLoader:(id)sender didLoadBundle:(NSBundle *)aBundle;

@end
