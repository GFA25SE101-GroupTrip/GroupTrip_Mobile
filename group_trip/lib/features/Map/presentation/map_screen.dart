import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:group_trip/features/staff/providers/staff_providers.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  final List<LocationPoint>? locations;
  final double? latitude;
  final double? longitude;
  final String? title;

  const MapScreen({
    Key? key,
    this.locations,
    this.latitude,
    this.longitude,
    this.title,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  late LatLng centerLocation;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    
    // Xác định vị trí trung tâm
    if (widget.locations != null && widget.locations!.isNotEmpty) {
      // Tính bounds của tất cả markers
      double minLat = widget.locations![0].latitude;
      double maxLat = widget.locations![0].latitude;
      double minLng = widget.locations![0].longitude;
      double maxLng = widget.locations![0].longitude;
      
      for (final loc in widget.locations!) {
        minLat = minLat > loc.latitude ? loc.latitude : minLat;
        maxLat = maxLat < loc.latitude ? loc.latitude : maxLat;
        minLng = minLng > loc.longitude ? loc.longitude : minLng;
        maxLng = maxLng < loc.longitude ? loc.longitude : maxLng;
      }
      
      // Tính center của bounds
      centerLocation = LatLng(
        (minLat + maxLat) / 2,
        (minLng + maxLng) / 2,
      );
      
      // ✅ Tính zoom level để fit tất cả markers
      final distance = _calculateDistance(minLat, minLng, maxLat, maxLng);
      _autoZoom = _calculateZoomLevel(distance);
    } else if (widget.latitude != null && widget.longitude != null) {
      // Nếu có tọa độ đơn lẻ
      centerLocation = LatLng(widget.latitude!, widget.longitude!);
      _autoZoom = 15.0;
    } else {
      // Default: Hà Nội
      centerLocation = const LatLng(21.0285, 105.8542);
      _autoZoom = 13.0;
    }
  }

  /// 📍 Tính khoảng cách giữa 2 điểm (km)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371; // Radius của Trái Đất (km)
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double degree) => degree * (3.141592653589793 / 180);

  /// 📍 Tính zoom level dựa trên khoảng cách
  double _calculateZoomLevel(double distanceKm) {
    if (distanceKm < 0.1) return 17.0;
    if (distanceKm < 0.5) return 16.0;
    if (distanceKm < 1) return 15.0;
    if (distanceKm < 5) return 13.0;
    if (distanceKm < 10) return 12.0;
    if (distanceKm < 50) return 10.0;
    if (distanceKm < 100) return 9.0;
    return 8.0;
  }

  late double _autoZoom;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  /// 🎨 Chọn màu dựa trên type vị trí
  Color _getMarkerColor(String type) {
    switch (type.toLowerCase()) {
      case 'trip':
        return Colors.red;
      case 'segment':
        return Colors.blue;
      case 'poi':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// 🔤 Chọn icon dựa trên type vị trí
  IconData _getMarkerIcon(String type) {
    switch (type.toLowerCase()) {
      case 'trip':
        return Icons.location_on;
      case 'segment':
        return Icons.directions;
      case 'poi':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách markers từ locations
    final markers = <Marker>[];
    
    if (widget.locations != null) {
      for (int i = 0; i < widget.locations!.length; i++) {
        final loc = widget.locations![i];
        final color = _getMarkerColor(loc.type);
        final icon = _getMarkerIcon(loc.type);
        
        markers.add(
          Marker(
            point: LatLng(loc.latitude, loc.longitude),
            width: 80,
            height: 80,
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                // Nhãn vị trí
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    loc.name.length > 15 ? '${loc.name.substring(0, 12)}...' : loc.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (widget.latitude != null && widget.longitude != null) {
      // Single location marker
      markers.add(
        Marker(
          point: LatLng(widget.latitude!, widget.longitude!),
          width: 80,
          height: 80,
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Bản đồ'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: centerLocation,
          zoom: _autoZoom,
          minZoom: 5.0,
          maxZoom: 18.0,
        ),
        children: [
          // ✅ CartoDB tile layer (better rate limit policy)
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            userAgentPackageName: 'com.grouptrip.app',
            subdomains: const ['a', 'b', 'c', 'd'],
            // 🚀 Performance optimization
            tileSize: 256,
            maxZoom: 18,
            maxNativeZoom: 19,
            // ✅ Keep tiles in memory một thời gian
            keepBuffer: 5,
            // ✅ Giảm tile requests khi pan
            panBuffer: 1,
          ),
          // Markers layer
          MarkerLayer(markers: markers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            onPressed: () {
              mapController.move(
                mapController.center,
                mapController.zoom + 1,
              );
            },
            tooltip: 'Phóng to',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'zoom_out',
            onPressed: () {
              mapController.move(
                mapController.center,
                mapController.zoom - 1,
              );
            },
            tooltip: 'Thu nhỏ',
            child: const Icon(Icons.remove),
          ),
          if (widget.locations != null && widget.locations!.isNotEmpty) ...[
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'info',
              onPressed: () {
                _showLocationsList(context);
              },
              tooltip: 'Danh sách vị trí',
              child: const Icon(Icons.list),
            ),
          ]
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  /// 📋 Hiển thị danh sách vị trí trong dialog
  void _showLocationsList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Danh sách vị trí'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.locations!.length,
            itemBuilder: (context, index) {
              final loc = widget.locations![index];
              final color = _getMarkerColor(loc.type);
              return ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getMarkerIcon(loc.type),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                title: Text(loc.name),
                subtitle: Text('${loc.type} • ${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
