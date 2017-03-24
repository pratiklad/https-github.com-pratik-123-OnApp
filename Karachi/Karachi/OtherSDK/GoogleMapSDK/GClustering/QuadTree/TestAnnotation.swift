//
//  TestAnnotation.swift
//  VTSFinal
//
//  Created by Ruchita Patel on 08/04/15.
//  Copyright (c) 2015 Uffizio India Software Consultant Pvt Ltd. All rights reserved.
//


import Foundation
import MapKit.MKAnnotation

class TestAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
