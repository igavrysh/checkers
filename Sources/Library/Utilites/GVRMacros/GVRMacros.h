//
//  GVRMacro.h
//  iOSProject
//
//  Created by Ievgen on 8/2/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#import "GVRCompilerMacros.h"

#define kGVRStringVariableDefinition(variable, value)   static NSString * const variable = value

#define kGVRStringKeyDefinition(key)    kGVRStringVariableDefinition(key, @#key)

#define GVREmpty

#define GVRDefineBaseViewProperty(viewClass, propertyName) \
    @property (nonatomic, readonly) viewClass     *propertyName;

#define GVRBaseViewGetterSynthesize(viewClass, propertyName) \
    @dynamic propertyName; \
    \
    - (viewClass *)propertyName { \
        if ([self isViewLoaded] && [self.view isKindOfClass:[viewClass class]]) { \
            return (viewClass *)self.view; \
        } \
        \
        return nil; \
    }

#define GVRViewControllerBaseViewProperty(viewControllerClass, baseViewClass, propertyName) \
    @interface viewControllerClass (__GVRPrivateBaseView) \
    GVRDefineBaseViewProperty(baseViewClass, propertyName); \
    \
    @end \
    \
    @implementation viewControllerClass (__GVRPrivateBaseView) \
    \
    GVRBaseViewGetterSynthesize(baseViewClass, propertyName); \
    \
    @end \

#define GVRWeakify(variable) \
    __weak __typeof(variable) __GVRWeakified_##variable = variable;

#define GVRPerformBlock(block, ...) \
    if (block) { \
        block(__VA_ARGS__); \
    } \

#define GVRPrintMethod NSLog(@"%@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

// you should only call this method after you called weakify for the same variable
#define GVRStrongify(variable) \
    GVRClangDiagnosticPushExpression("clang diagnostic ignored \"-Wshadow\""); \
    __strong __typeof(variable) variable = __GVRWeakified_##variable; \
    GVRClangDiagnosticPopExpression;

#define GVRStrongifyAndReturnIfNil(variable) \
    GVRStrongifyAndReturnResultIfNil(variable, GVREmpty) \

#define GVRStrongifyAndReturnNilIfNil(variable) \
    GVRStrongifyAndReturnResultIfNil(variable, nil)

#define GVRStrongifyAndReturnResultIfNil(variable, result) \
    GVRStrongify(variable); \
    if (!variable) { \
        return result; \
    } \
