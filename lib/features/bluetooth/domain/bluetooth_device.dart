class BluetoothDevice {
  final String? name;
  final String address;

  const BluetoothDevice({required this.name, required this.address});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDevice && other.address == address;

  @override
  int get hashCode => address.hashCode;
}
