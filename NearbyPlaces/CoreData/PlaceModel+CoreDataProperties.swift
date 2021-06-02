//
//  PlaceModel+CoreDataProperties.swift
//  NearbyPlaces
//
//  Created by Artem Kupriianets on 02.06.2021.
//
//

import Foundation
import CoreData

extension PlaceModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceModel> {
        return NSFetchRequest<PlaceModel>(entityName: "PlaceModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?
    @NSManaged public var type: String?
    @NSManaged public var phone: String?
    @NSManaged public var zip: String?
    @NSManaged public var score: Double
    @NSManaged public var queryLatitude: Double
    @NSManaged public var queryLongitude: Double

}

extension PlaceModel: Identifiable {

}
