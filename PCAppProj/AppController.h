/* 
 * AppController.h created by phr on 2000-08-27 11:38:59 +0000
 *
 * Project TestApp
 *
 * Created with ProjectCenter - http://www.projectcenter.ch
 *
 * $Id$
 */

#import <AppKit/AppKit.h>

@interface AppController : NSObject
{
}

+ (void)initialize;

- (id)init;
- (void)dealloc;

- (void)awakeFromNib;

- (void)applicationDidFinishLaunching:(NSNotification *)notif;

- (void)applicationShouldTerminate:(id)sender;
- (void)applicationWillTerminate:(NSNotification *)notification;
- (BOOL)application:(NSApplication *)application openFile:(NSString *)fileName;

- (void)showPrefPanel:(id)sender;

@end
