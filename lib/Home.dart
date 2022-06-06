import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = const CameraPosition(
      target: LatLng(-23.419357, -51.932216),
      zoom: 16
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _poligons  = {};

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
      )
    );
  }

  _carregarMarcadores(){
    /*
    Set<Marker> _marcadoresLocal = {};
    Marker marcadorShopping = Marker(
      markerId: MarkerId("marcador-shopping"),
      position: LatLng(-23.419357, -51.932216),
      infoWindow: InfoWindow(
        title: "Sopping Av. Center"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue
      ),
      onTap: (){
        print("Shopping clicado!!!");
      }
      //rotation: 45
    );

    Marker marcadorLoterica = Marker(
      markerId: MarkerId("marcador-loterica"),
      position: LatLng(-23.419609, -51.933245),
        infoWindow: InfoWindow(
            title: "loterica"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange
        ),
        onTap: (){
          print("Loterica clicado!!!");
        }
    );

    _marcadoresLocal.add(marcadorShopping);
    _marcadoresLocal.add(marcadorLoterica);

    setState(() {
      _marcadores = _marcadoresLocal;
    });
     */

    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.green,
        strokeColor: Colors.red,
      strokeWidth: 10,
      points:[
        LatLng(-23.418280, -51.932941),
        LatLng(-23.419973, -51.932963),
        LatLng(-23.419998, -51.931595),
        LatLng(-23.418449, -51.931600),
      ],
      consumeTapEvents: true,
      onTap: (){
          print("clicado na area");
      }
    );

    listaPolygons.add( polygon1 );

    setState(() {
      _poligons = listaPolygons;
    });
    
  }

  _recuperarLocalizacaoAtual() async {
    LocationPermission permission;
    await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    Position position =  await Geolocator.getCurrentPosition(
        desiredAccuracy:  LocationAccuracy.high
    );

    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17
      );
      _movimentarCamera();
    });

    //print("localização atual: " + position.toString());
  }

  _recuperarLocalParaEndereco() async {

    List <Location> listaLocalizacoes = await GeocodingPlatform.instance.locationFromAddress("Av. Paulista, 1372");

    if( listaLocalizacoes != null && listaLocalizacoes.length > 0 ){
      Location localizacao = listaLocalizacoes[0];
      List<Placemark> listaEnderecos = await GeocodingPlatform.instance.placemarkFromCoordinates(localizacao.latitude, localizacao.longitude);
      if(listaEnderecos != null && listaEnderecos.length > 0){
        Placemark endereco = listaEnderecos[0];
        String resultado;
        resultado = "\n AdministrativoArea ${endereco.administrativeArea}";
        resultado += "\n SubAdministrativoArea ${endereco.subAdministrativeArea}";
        resultado += "\n Locality ${endereco.locality}";
        resultado += "\n SubLocality ${endereco.subLocality}";
        resultado += "\n Thoroughfare ${endereco.thoroughfare}";
        resultado += "\n PostalCode ${endereco.postalCode}";
        resultado += "\n Country ${endereco.country}";
        resultado += "\n IsoCountryCode ${endereco.isoCountryCode}";
        resultado += "\n Position latitude: ${localizacao.latitude} longitute: ${localizacao.longitude}";
        print("resultado: $resultado");
        //-23.425643, -51.939042
      }
    }

  }

  _recuperarEnderecoParaLatLong() async {

    List <Location> listaLocalizacoes = await GeocodingPlatform.instance.locationFromAddress("Av. Paulista, 1372");

    if( listaLocalizacoes != null && listaLocalizacoes.length > 0 ){
      Location localizacao = listaLocalizacoes[0];
      List<Placemark> listaEnderecos = await GeocodingPlatform.instance.placemarkFromCoordinates(-23.425643, -51.939042);
      if(listaEnderecos != null && listaEnderecos.length > 0){
        Placemark endereco = listaEnderecos[0];
        String resultado;
        resultado = "\n AdministrativoArea ${endereco.administrativeArea}";
        resultado += "\n SubAdministrativoArea ${endereco.subAdministrativeArea}";
        resultado += "\n Locality ${endereco.locality}";
        resultado += "\n SubLocality ${endereco.subLocality}";
        resultado += "\n Thoroughfare ${endereco.thoroughfare}";
        resultado += "\n PostalCode ${endereco.postalCode}";
        resultado += "\n Country ${endereco.country}";
        resultado += "\n IsoCountryCode ${endereco.isoCountryCode}";
        resultado += "\n Position latitude: ${localizacao.latitude} longitute: ${localizacao.longitude}";
        print("resultado: $resultado");
        //-23.425643, -51.939042
      }
    }

  }

  @override
  void initState() {
    super.initState();
    //_recuperarLocalizacaoAtual();
    //_carregarMarcadores();
    //_adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarEnderecoParaLatLong();
  }

  _adicionarListenerLocalizacao(){

    var locationSetting = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
     var geolocator = Geolocator.getPositionStream(locationSettings: locationSetting).listen((Position position) {
       print("localização atual: " + position.toString());

       Marker marcadorUsuario = Marker(
           markerId: MarkerId("marcador-usuario"),
           position: LatLng(position.latitude, position.longitude),
           infoWindow: InfoWindow(
               title: "Meu local"
           ),
           icon: BitmapDescriptor.defaultMarkerWithHue(
               BitmapDescriptor.hueMagenta
           ),
           onTap: (){
             print("Meu local clicado!!!");
           }
         //rotation: 45
       );

       setState(() {
         //_marcadores.add(marcadorUsuario);
         _posicaoCamera = CameraPosition(
             target: LatLng(position.latitude, position.longitude),
             zoom: 17
         );
         _movimentarCamera();
       });
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e geolocalização"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
      body: Container(
        child: GoogleMap(
            mapType: MapType.normal,
            //-23.425608, -51.937816
            initialCameraPosition: _posicaoCamera,
           onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: _marcadores,
            //polygons: _poligons,
        ),
      ),
    );
  }
}
