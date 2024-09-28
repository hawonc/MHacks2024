#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "bottleMed" asset catalog image resource.
static NSString * const ACImageNameBottleMed AC_SWIFT_PRIVATE = @"bottleMed";

/// The "medicinebottle" asset catalog image resource.
static NSString * const ACImageNameMedicinebottle AC_SWIFT_PRIVATE = @"medicinebottle";

#undef AC_SWIFT_PRIVATE
