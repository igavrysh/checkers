//
//  GVRCompilerMacro.h
//  iOSProject
//
//  Created by Ievgen on 8/9/16.
//  Copyright © 2016 1mlndollarsasset. All rights reserved.
//

#define GVRClnagDiagnosticPush _Pragma("clang diagnostic push")
#define GVRClangDiagnosticPop _Pragma("clang diagnostic pop")

#define GVRClangDiagnosticPushExpression(key) \
    GVRClnagDiagnosticPush \
    _Pragma(key)

#define GVRClangDiagnosticPopExpression GVRClangDiagnosticPop

#define GVRClangIgnoredPerformSelectorLeaksPush  \
    GVRClangDiagnosticPushExpression("clang diagnostic ignored \"-Warc-performSelector-leaks\"")

#define GVRClangIgnoredPerformSelectorLeaksPop GVRClangDiagnosticPop

#define GVRClangIgnorePerformSelectorWarning(code) \
    do { \
        GVRClangDiagnosticPushExpression("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        code \
        GVRClangDiagnosticPopExpression \
    } while(0)


