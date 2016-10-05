//
//  GMSAddressComponent.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * Represents a component of an address, e.g., street number, postcode, city, etc.
 */
@interface GMSAddressComponent : NSObject

/**
 * Type of the address component. For a list of supported types, see
 * https://developers.google.com/places/supported_types#table2. This string will be one of the
 * constants defined in GMSPlaceTypes.h.
 */
@property(nonatomic, readonly, copy) NSString *type;

/** Name of the address component, e.g. "Sydney" */
@property(nonatomic, readonly, copy) NSString *name;

@end

GMS_ASSUME_NONNULL_END
