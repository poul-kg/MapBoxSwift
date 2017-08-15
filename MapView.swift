//
//  MapView.swift
//  MapBoxTesting
//
//  Created by Dhvl's iMac on 11/08/17.
//  Copyright © 2017 Dhvl's iMac. All rights reserved.
//

import UIKit
import Mapbox

public class MapView: UIView, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    var annotationObjectArray = [AnnotationObject]()
    var nameArray = ["Sushi!", "Ravel!", "Denial"]
    var colorArray = ["FF6266", "38D9A9", "3097EC"]
    var timeArray = ["6:00 AM", "5:00 AM", "7:00 AM"]
    
    public var annotationSelectCallback:((AnnotationObject) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMapAndAnnotation()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addMapAndAnnotation() {
        mapView = MGLMapView(frame: self.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.outdoorsStyleURL()
        mapView.tintColor = .lightGray
        mapView.setCenter(CLLocationCoordinate2D(latitude: 39.7468,
                                                 longitude: -104.9923),
                          zoomLevel: 13, animated: false)
        mapView.delegate = self
        self.addSubview(mapView)
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 39.7418, longitude: -104.9823),
            CLLocationCoordinate2D(latitude: 39.7468, longitude: -104.9923),
            CLLocationCoordinate2D(latitude: 39.7358, longitude: -105.0023),
            ]
        appendAnnotationObject(coordinates: coordinates)
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = ""
            pointAnnotations.append(point)
        }
        
        mapView.addAnnotations(pointAnnotations)
    }
    
    func addAnnotation(annotationObject : AnnotationObject) {
        let point = MGLPointAnnotation()
        point.coordinate = annotationObject.locationCoordinate!
        point.title = annotationObject.id
        mapView.addAnnotation(point)
    }
    
    func appendAnnotationObject(coordinates : [CLLocationCoordinate2D]) {
        for i in 0..<coordinates.count {
            let annotationObject = AnnotationObject(initWith: nameArray[i], time: timeArray[i], locationCoordinate: coordinates[i], id: "first", color: colorArray[i])
            annotationObjectArray.append(annotationObject)
        }
    }
    
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.latitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? CustomAnnotationView
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier : reuseIdentifier)
            let displayingAnnotationObject = annotationObjectArray.filter( { return $0.locationCoordinate?.latitude == annotation.coordinate.latitude &&  $0.locationCoordinate?.longitude == annotation.coordinate.longitude } ).first
            if displayingAnnotationObject != nil {
                annotationView?.setParameters(userNameSting: displayingAnnotationObject!.userName, timeString: displayingAnnotationObject!.time, colorCode: displayingAnnotationObject!.color)
            }
        }
        return annotationView
    }
    
    public func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    public func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        if let annotationView : CustomAnnotationView = annotationView as? CustomAnnotationView {
            let identifier = annotationView.reuseIdentifier
            
            let latitude = NumberFormatter().number(from: identifier!)!.doubleValue
            
            let selectedAnnotationObject = annotationObjectArray.filter( { return $0.locationCoordinate?.latitude == latitude } ).first
            if selectedAnnotationObject != nil {
                annotationSelectCallback!(selectedAnnotationObject!)
            }
        }
        
        let selectedAnnotations = self.mapView.selectedAnnotations
        for annotation in selectedAnnotations {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
}

public class CustomAnnotationView : MGLAnnotationView {
    var label : UILabel?
    var userNameString = ""
    var timeString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        label = UILabel()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        scalesWithViewingDistance = false
        self.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 7)
    }
    
    func setParameters(userNameSting : String, timeString : String, colorCode : String) {
        self.backgroundColor = UIColor(hexString: colorCode)
        let userString = NSAttributedString(string: userNameSting + " @ ", attributes: [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12.0)!])
        let timeLabelString = NSAttributedString(string: timeString, attributes: [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!])
        
        let mainAttributeString = NSMutableAttributedString(attributedString: userString)
        mainAttributeString.append(timeLabelString)
        
        label?.attributedText = mainAttributeString
        
        label?.sizeToFit()
        label?.isUserInteractionEnabled = false
        
        label!.frame = CGRect(x: 10, y: 5, width: label!.frame.size.width, height: label!.frame.size.height)
        self.addSubview(label!)
        self.frame = CGRect(x: 0, y: 0, width: label!.frame.size.width + 20, height: label!.frame.size.height + 10)
        
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
