
#import <Foundation/Foundation.h>
#import <YouTubeHeader/YTIElementRenderer.h>

#pragma mark - Hide Shorts in Feed
%hook YTIElementRenderer
- (NSData *)elementData {
    NSString *desc = [self description] ?: @"";
    BOOL hide = ([desc containsString:@"shorts_shelf"] ||
                 [desc containsString:@"shorts_video_cell"] ||
                 [desc containsString:@"shorts_grid_shelf_footer"] ||
                 [desc containsString:@"youtube_shorts_24"] ||
                 ([desc containsString:@"compact_video.eml"] && [desc containsString:@"youtube_shorts_"]));
    if (hide) {
        return [NSData data];
    }
    return %orig;
}
%end

#pragma mark - Hide Shorts Tab in Pivot Bar
%hook YTPivotBarView
- (void)setRenderer:(id)renderer {
    NSMutableArray *itemsArray = [renderer valueForKey:@"itemsArray"];
    if (itemsArray) {
        NSUInteger indexToRemove = NSNotFound;
        for (NSUInteger i = 0; i < itemsArray.count; i++) {
            id item = itemsArray[i];
            id pivotBarItemRenderer = [item valueForKey:@"pivotBarItemRenderer"];
            NSString *pivotIdentifier = [pivotBarItemRenderer valueForKey:@"pivotIdentifier"];
            if ([pivotIdentifier.lowercaseString containsString:@"shorts"]) {
                indexToRemove = i;
                break;
            }
        }
        if (indexToRemove != NSNotFound) {
            [itemsArray removeObjectAtIndex:indexToRemove];
        }
    }
    %orig;
}
%end
