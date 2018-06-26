//
//  MWPreprocessor.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 01/10/2013.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 两种 weakself 写法
#define __BJPBWeakSelf__  __weak typeof (self)
#define __BJPBWeakObject(object) __weak typeof (object)

#define BJPBweakifyself __BJPBWeakSelf__ wSelf = self;
#define BJPBstrongifyself __BJPBWeakSelf__ self = wSelf;

#define BJPBweakifyobject(obj) __BJPBWeakObject(obj) $##obj = obj;
#define BJPBstrongifobject(obj) __BJPBWeakObject(obj) obj = $##obj;


#define PADDING 10