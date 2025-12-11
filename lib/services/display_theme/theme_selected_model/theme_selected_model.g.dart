// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_selected_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppThemeEnumAdapter extends TypeAdapter<AppThemeEnum> {
  @override
  final int typeId = 0;

  @override
  AppThemeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeEnum.system;
      case 1:
        return AppThemeEnum.light;
      case 2:
        return AppThemeEnum.dark;
      default:
        return AppThemeEnum.system;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeEnum obj) {
    switch (obj) {
      case AppThemeEnum.system:
        writer.writeByte(0);
        break;
      case AppThemeEnum.light:
        writer.writeByte(1);
        break;
      case AppThemeEnum.dark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
