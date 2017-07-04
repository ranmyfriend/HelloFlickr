//
//  Place.swift
//
//  Created by Ranjith Kumar on 7/5/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Place {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kPlaceLatitudeKey: String = "latitude"
  private let kPlaceNameKey: String = "name"
  private let kPlacePlaceTypeKey: String = "place_type"
  private let kPlacePlaceTypeIdKey: String = "place_type_id"
  private let kPlacePlaceUrlKey: String = "place_url"
  private let kPlaceTimezoneKey: String = "timezone"
  private let kPlacePlaceIdKey: String = "place_id"
  private let kPlaceWoeNameKey: String = "woe_name"
  private let kPlaceLongitudeKey: String = "longitude"
  private let kPlaceWoeidKey: String = "woeid"

  // MARK: Properties
  public var latitude: String?
  public var name: String?
  public var placeType: String?
  public var placeTypeId: String?
  public var placeUrl: String?
  public var timezone: String?
  public var placeId: String?
  public var woeName: String?
  public var longitude: String?
  public var woeid: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    latitude = json[kPlaceLatitudeKey].string
    name = json[kPlaceNameKey].string
    placeType = json[kPlacePlaceTypeKey].string
    placeTypeId = json[kPlacePlaceTypeIdKey].string
    placeUrl = json[kPlacePlaceUrlKey].string
    timezone = json[kPlaceTimezoneKey].string
    placeId = json[kPlacePlaceIdKey].string
    woeName = json[kPlaceWoeNameKey].string
    longitude = json[kPlaceLongitudeKey].string
    woeid = json[kPlaceWoeidKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = latitude { dictionary[kPlaceLatitudeKey] = value }
    if let value = name { dictionary[kPlaceNameKey] = value }
    if let value = placeType { dictionary[kPlacePlaceTypeKey] = value }
    if let value = placeTypeId { dictionary[kPlacePlaceTypeIdKey] = value }
    if let value = placeUrl { dictionary[kPlacePlaceUrlKey] = value }
    if let value = timezone { dictionary[kPlaceTimezoneKey] = value }
    if let value = placeId { dictionary[kPlacePlaceIdKey] = value }
    if let value = woeName { dictionary[kPlaceWoeNameKey] = value }
    if let value = longitude { dictionary[kPlaceLongitudeKey] = value }
    if let value = woeid { dictionary[kPlaceWoeidKey] = value }
    return dictionary
  }

}
