import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "ADDRESS KEY";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        child: Center(
          child: InkWell(
            onTap: () async {
              Prediction p = await PlacesAutocomplete.show(
                  context: context, apiKey: kGoogleApiKey);
              displayPrediction(p);
            },
            child: Text("Tap Me"),
          ),
        ),
      ),
    );
  }
}
