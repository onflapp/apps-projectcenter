/* 
 * PCMakefileFactory.m created by probert on 2002-02-28 22:16:25 +0000
 *
 * Project ProjectCenter
 *
 * Created with ProjectCenter - http://www.gnustep.org
 *
 * $Id$
 */

#import "PCMakefileFactory.h"

#define COMMENT_HEADERS     @"\n\n#\n# Header files\n#\n\n"
#define COMMENT_RESOURCES   @"\n\n#\n# Resource files\n#\n\n"
#define COMMENT_CLASSES     @"\n\n#\n# Class files\n#\n\n"
#define COMMENT_CFILES      @"\n\n#\n# C files\n#\n\n"
#define COMMENT_SUBPROJECTS @"\n\n#\n# Subprojects\n#\n\n"
#define COMMENT_APP         @"\n\n#\n# Main application\n#\n\n"
#define COMMENT_LIBRARIES   @"\n\n#\n# Additional libraries\n#\n\n"
#define COMMENT_BUNDLE      @"\n\n#\n# Bundle\n#\n\n"
#define COMMENT_LIBRARY     @"\n\n#\n# Library\n#\n\n"
#define COMMENT_TOOL        @"\n\n#\n# Tool\n#\n\n"

@implementation PCMakefileFactory

static PCMakefileFactory *_factory = nil;

+ (PCMakefileFactory *)sharedFactory
{
    static BOOL isInitialised = NO;

    if( isInitialised == NO )
    {
        _factory = [[PCMakefileFactory alloc] init];

        isInitialised = YES;
    }

    return _factory;
}

- (void)createMakefileForProject:(NSString *)prName
{
    NSAssert( prName, @"No project name given!");

    AUTORELEASE( mfile );
    mfile = [[NSMutableString alloc] init];

    AUTORELEASE( pnme );
    pnme = [prName copy];

    [mfile appendString:@"#\n"];
    [mfile appendString:@"# GNUmakefile - Generated by ProjectCenter\n"];
    [mfile appendString:@"# Written by Philippe C.D. Robert <phr@3dkit.org>\n"];
    [mfile appendString:@"#\n"];
    [mfile appendString:@"# NOTE: Do NOT change this file -- ProjectCenter maintains it!\n"];
    [mfile appendString:@"#\n"];
    [mfile appendString:@"# Put all of your customisations in GNUmakefile.preamble and\n"];
    [mfile appendString:@"# GNUmakefile.postamble\n"];
    [mfile appendString:@"#\n\n"];
}

- (void)appendString:(NSString *)aString
{
    NSAssert( mfile, @"No valid makefile available!");
    NSAssert( aString, @"No valid string!");

    [mfile appendString:aString];
}

- (void)appendHeaders:(NSArray *)array
{
    [self appendString:COMMENT_HEADERS];
    [self appendString:[NSString stringWithFormat:@"%@_HEADERS= ",pnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

	while (tmp = [enumerator nextObject]) 
        {
	    [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
	}
    }
}

- (void)appendClasses:(NSArray *)array
{
    [self appendString:COMMENT_CLASSES];
    [self appendString:[NSString stringWithFormat:@"%@_OBJC_FILES= ",pnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

	while (tmp = [enumerator nextObject]) 
        {
	    [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
	}
    }
}

- (void)appendCFiles:(NSArray *)array
{
    [self appendString:COMMENT_CFILES];
    [self appendString:[NSString stringWithFormat:@"%@_C_FILES= ",pnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

	while (tmp = [enumerator nextObject]) 
        {
	    [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
	}
    }
}

- (void)appendInstallDir:(NSString*)dir
{
    [self appendString:
             [NSString stringWithFormat:@"GNUSTEP_INSTALLATION_DIR=%@\n",dir]];
}

- (void)appendResources
{
    [self appendString:COMMENT_RESOURCES];
    [self appendString:[NSString stringWithFormat:@"%@_RESOURCE_FILES= ",pnme]];
}

- (void)appendResourceItems:(NSArray *)array
{
    NSString     *tmp;
    NSEnumerator *enumerator = [array objectEnumerator];

    while (tmp = [enumerator nextObject]) {
	[self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
    }
}

- (void)appendSubprojects:(NSArray*)array
{
    [self appendString:COMMENT_SUBPROJECTS];

    if (array && [array count]) 
    {
	NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject]) {
            [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
        }
    }

}

- (void)appendTailForApp
{
    [self appendString:@"\n\n"];

    [self appendString:@"-include GNUmakefile.preamble\n"];
    [self appendString:@"-include GNUmakefile.local\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/aggregate.make\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/application.make\n"];
    [self appendString:@"-include GNUmakefile.postamble\n"];
}

- (void)appendTailForLibrary
{
    NSString *libnme = [NSString stringWithFormat:@"lib%@",pnme];
    NSString *hinst;

    [self appendString:@"\n\n"];

    hinst = [NSString stringWithFormat:@"HEADERS_INSTALL = $(%@_HEADER_FILES)\n\n",libnme];
    [self appendString:hinst];

    [self appendString:@"-include GNUmakefile.preamble\n"];
    [self appendString:@"-include GNUmakefile.local\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/library.make\n"];
    [self appendString:@"-include GNUmakefile.postamble\n"];
}

- (void)appendTailForTool
{
    [self appendString:@"\n\n"];

    [self appendString:@"-include GNUmakefile.preamble\n"];
    [self appendString:@"-include GNUmakefile.local\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/aggregate.make\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/tool.make\n"];
    [self appendString:@"-include GNUmakefile.postamble\n"];
}

- (void)appendTailForBundle
{
    [self appendString:@"\n\n"];

    [self appendString:@"-include GNUmakefile.preamble\n"];
    [self appendString:@"-include GNUmakefile.local\n"];
    [self appendString:@"include $(GNUSTEP_MAKEFILES)/bundle.make\n"];
    [self appendString:@"-include GNUmakefile.postamble\n"];
}

- (void)appendTailForGormApp
{
    [self appendString:@""];
}

- (NSData *)encodedMakefile
{
    NSAssert( mfile, @"No valid makefile available!");

    return [mfile dataUsingEncoding:[NSString defaultCStringEncoding]];
}

@end

@implementation PCMakefileFactory (ApplicationProject)

- (void)appendApplication
{
    [self appendString:COMMENT_APP];

    [self appendString:[NSString stringWithFormat:@"PACKAGE_NAME=%@\n",pnme]];
    [self appendString:[NSString stringWithFormat:@"APP_NAME=%@\n",pnme]];
}

- (void)appendAppIcon:(NSString*)icn
{
    [self appendString:
             [NSString stringWithFormat:@"%@_APPLICATION_ICON=%@\n",pnme, icn]];
}

- (void)appendGuiLibraries:(NSArray*)array
{
    [self appendString:COMMENT_LIBRARIES];
    [self appendString:@"ADDITIONAL_GUI_LIBS += "];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject]) 
        {
          if (![tmp isEqualToString:@"gnustep-base"] &&
              ![tmp isEqualToString:@"gnustep-gui"]) 
          {
            [self appendString:[NSString stringWithFormat:@"-l%@ ",tmp]];
          }
        }
    }
}

@end

@implementation PCMakefileFactory (BundleProject)

- (void)appendBundle
{
    [self appendString:COMMENT_BUNDLE];

    [self appendString:[NSString stringWithFormat:@"PACKAGE_NAME=%@\n",pnme]];
    [self appendString:[NSString stringWithFormat:@"BUNDLE_NAME=%@\n",pnme]];
    [self appendString:[NSString stringWithFormat:@"BUNDLE_EXTENSION=.bundle\n"]];

}

- (void)appendPrincipalClass:(NSString *)cname
{
    [self appendString:
             [NSString stringWithFormat:@"%@_PRINCIPAL_CLASS=%@\n",pnme,cname]];

}

- (void)appendBundleInstallDir:(NSString*)dir
{
    [self appendString:
                    [NSString stringWithFormat:@"BUNDLE_INSTALL_DIR=%@\n",dir]];
}

- (void)appendLibraries:(NSArray*)array
{
    [self appendString:COMMENT_LIBRARIES];

    [self appendString:
              [NSString stringWithFormat:@"%@_LIBRARIES_DEPEND_UPON += ",pnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject]) 
        {
          if (![tmp isEqualToString:@"gnustep-base"] &&
              ![tmp isEqualToString:@"gnustep-gui"]) 
          {
            [self appendString:[NSString stringWithFormat:@"-l%@ ",tmp]];
          }
        }
    }
}

@end

@implementation PCMakefileFactory (LibraryProject)

- (void)appendLibrary
{
    NSString *libnme;

    [self appendString:COMMENT_LIBRARY];

    [self appendString:[NSString stringWithFormat:@"PACKAGE_NAME=%@\n",pnme]];
    [self appendString:[NSString stringWithFormat:@"LIBRARY_VAR=%@\n",[pnme uppercaseString]]];

    libnme = [NSString stringWithFormat:@"lib%@",pnme];
    [self appendString:[NSString stringWithFormat:@"LIBRARY_NAME=%@\n",libnme]];

    [self appendString:[NSString stringWithFormat:@"%@_HEADER_FILES_DIR=.\n",libnme]];
    [self appendString:[NSString stringWithFormat:@"%@_HEADER_FILES_INSTALL_DIR=/%@\n",libnme,pnme]];

    [self appendString:@"ADDITIONAL_INCLUDE_DIRS = -I..\n"];
    [self appendString:@"srcdir = .\n"];
}

- (void)appendLibraryInstallDir:(NSString*)dir
{
    //[self appendString:[NSString stringWithFormat:@"GNUSTEP_INSTALLATION_DIR=%@\n",dir]];
    [self appendString:[NSString stringWithFormat:@"%@_INSTALLATION_DIR=$(GNUSTEP_INSTALLATION_DIR)\n",[pnme uppercaseString]]];
    [self appendString:[NSString stringWithFormat:@"%@_INSTALL_PREFIX=$(GNUSTEP_INSTALLATION_DIR)\n",[pnme uppercaseString]]];
}

- (void)appendLibraryLibraries:(NSArray*)array
{
    NSString *libnme = [NSString stringWithFormat:@"lib%@",pnme];

    [self appendString:COMMENT_LIBRARIES];

    [self appendString:
            [NSString stringWithFormat:@"%@_LIBRARIES_DEPEND_UPON += ",libnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject]) 
        {
          if (![tmp isEqualToString:@"gnustep-base"])
          {
            [self appendString:[NSString stringWithFormat:@"-l%@ ",tmp]];
          }
        }
    }
}

- (void)appendLibraryHeaders:(NSArray*)array
{
    NSString *libnme = [NSString stringWithFormat:@"lib%@",pnme];

    [self appendString:COMMENT_HEADERS];
    [self appendString:[NSString stringWithFormat:@"%@_HEADER_FILES= ",libnme]];
    
    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];
            
        while (tmp = [enumerator nextObject])
        {
            [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
        }
    }   
}

- (void)appendLibraryClasses:(NSArray *)array
{
    NSString *libnme = [NSString stringWithFormat:@"lib%@",pnme];

    [self appendString:COMMENT_CLASSES];
    [self appendString:[NSString stringWithFormat:@"%@_OBJC_FILES= ",libnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];
    
        while (tmp = [enumerator nextObject])
        {
            [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
        }
    }
}

- (void)appendLibraryCFiles:(NSArray *)array
{
    NSString *libnme = [NSString stringWithFormat:@"lib%@",pnme];

    [self appendString:COMMENT_CFILES];
    [self appendString:[NSString stringWithFormat:@"%@_C_FILES= ",libnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject])
        {
            [self appendString:[NSString stringWithFormat:@"\\\n%@ ",tmp]];
        }
    }
}

@end

@implementation PCMakefileFactory (ToolProject)

- (void)appendTool
{
    [self appendString:COMMENT_TOOL];

    [self appendString:[NSString stringWithFormat:@"PACKAGE_NAME=%@\n",pnme]];
    [self appendString:[NSString stringWithFormat:@"TOOL_NAME=%@\n",pnme]];

}

- (void)appendToolIcon:(NSString*)icn
{
    [self appendString:
                    [NSString stringWithFormat:@"%@_TOOL_ICON=%@\n",pnme, icn]];
}

- (void)appendToolLibraries:(NSArray*)array
{
    [self appendString:COMMENT_LIBRARIES];

    [self appendString:[NSString stringWithFormat:@"%@_TOOL_LIBS += ",pnme]];

    if( array && [array count] )
    {
        NSString     *tmp;
        NSEnumerator *enumerator = [array objectEnumerator];

        while (tmp = [enumerator nextObject]) 
        {
          if (![tmp isEqualToString:@"gnustep-base"])
          {
            [self appendString:[NSString stringWithFormat:@"-l%@ ",tmp]];
          }
        }
    }
}

@end

