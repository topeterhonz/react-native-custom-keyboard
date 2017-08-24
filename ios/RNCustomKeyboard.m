
#import "RNCustomKeyboard.h"
#import "RCTBridge+Private.h"
#import "RCTUIManager.h"

@implementation RNCustomKeyboard

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE(CustomKeyboard)

RCT_EXPORT_METHOD(install:(nonnull NSNumber *)reactTag withType:(nonnull NSString *)keyboardType maxLength:(int) maxLength)
{
  UIView* inputView = [[RCTRootView alloc] initWithBridge:((RCTBatchedBridge *)_bridge).parentBridge moduleName:@"CustomKeyboard" initialProperties:
    @{
      @"tag": reactTag,
      @"type": keyboardType
    }
  ];

  if (_dicInputMaxLength == nil) {
      _dicInputMaxLength = [NSMutableDictionary dictionaryWithCapacity:0];
  }
  
  [_dicInputMaxLength setValue:[NSNumber numberWithInt:maxLength] forKey:[reactTag stringValue]];

  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  view.inputView = inputView;
  [view reloadInputViews];
}

RCT_EXPORT_METHOD(uninstall:(nonnull NSNumber *)reactTag)
{
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  view.inputView = nil;
  [view reloadInputViews];
}

RCT_EXPORT_METHOD(getSelectionRange:(nonnull NSNumber *)reactTag callback:(RCTResponseSenderBlock)callback) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextRange* range = view.selectedTextRange;

  const NSInteger start = [view offsetFromPosition:view.beginningOfDocument toPosition:range.start];
  const NSInteger end = [view offsetFromPosition:view.beginningOfDocument toPosition:range.end];
  callback(@[@{@"text":view.text, @"start":[NSNumber numberWithInteger:start], @"end":[NSNumber numberWithInteger:end]}]);
}

RCT_EXPORT_METHOD(insertText:(nonnull NSNumber *)reactTag withText:(NSString*)text) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];
  if (_dicInputMaxLength != nil) {
    NSString *textValue = [NSString stringWithFormat:@"%@", view.text];
    int  maxLegth = [_dicInputMaxLength[reactTag.stringValue] intValue];
    if ([textValue length] >= maxLegth) {
        return;
    }
  }
  [view replaceRange:view.selectedTextRange withText:text];
}

RCT_EXPORT_METHOD(backSpace:(nonnull NSNumber *)reactTag) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  UITextRange* range = view.selectedTextRange;
  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    range = [view textRangeFromPosition:[view positionFromPosition:range.start offset:-1] toPosition:range.start];
  }
  [view replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(doDelete:(nonnull NSNumber *)reactTag) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  UITextRange* range = view.selectedTextRange;
  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    range = [view textRangeFromPosition:range.start toPosition:[view positionFromPosition: range.start offset: 1]];
  }
  [view replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(moveLeft:(nonnull NSNumber *)reactTag) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  UITextRange* range = view.selectedTextRange;
  UITextPosition* position = range.start;

  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    position = [view positionFromPosition: position offset: -1];
  }

  view.selectedTextRange = [view textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(moveRight:(nonnull NSNumber *)reactTag) {
  UITextView *view = (UITextView*)[_bridge.uiManager viewForReactTag:reactTag];

  UITextRange* range = view.selectedTextRange;
  UITextPosition* position = range.end;

  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    position = [view positionFromPosition: position offset: 1];
  }

  view.selectedTextRange = [view textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(switchSystemKeyboard:(nonnull NSNumber*) reactTag) {
  UITextView *view = [_bridge.uiManager viewForReactTag:reactTag];
  UIView* inputView = view.inputView;
  view.inputView = nil;
  [view reloadInputViews];
  view.inputView = inputView;
}

@end
  
