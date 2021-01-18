import 'package:extended_type/extended_type.dart';
import 'package:swiss_knife/swiss_knife.dart';

/// Base class for all Extended Types.
abstract class ExtendedType {
  static void initialize() {
    _registerTypes();
  }

  static final Map<String, ExtendedTypeHandler> typeHandlersRegistered = {};
  static final Map<int, ExtendedTypeHandler> typeHandlersRegisteredIDs = {};

  /// Used to register a [ExtendedTypeHandler] for type [T].
  static void registerTypeHandler<T extends ExtendedType>(
      ExtendedTypeHandler<T> typeHandler) {
    var typeName = typeHandler.getTypeName();
    var typeID = typeHandler.getTypeID();

    if (typeName == null || typeName.isEmpty || hasBlankChar(typeName)) {
      throw StateError('Invalid ExtendedType name: $typeName');
    }
    if (typeID <= 0) throw StateError("ExtendedType ID can't be <= 0: $typeID");

    if (typeHandlersRegistered.containsKey(typeName)) return;

    if (typeHandlersRegisteredIDs.containsKey(typeID)) {
      throw StateError(
          'TypeID[$typeID] conflict: $typeHandler != ${typeHandlersRegisteredIDs[typeID]}');
    }

    typeHandlersRegistered[typeName] = typeHandler;
    typeHandlersRegisteredIDs[typeID] = typeHandler;
  }

  /// Returns a [List] of registered [ExtendedTypeHandler].
  static List<ExtendedTypeHandler> getExtendedTypeHandlers() =>
      List.from(typeHandlersRegistered.values);

  /// Returns a [ExtendedTypeHandler] by [typeName].
  static T getExtendedTypeHandlerByName<T extends ExtendedTypeHandler>(
      String typeName) {
    initialize();
    T extendedTypeHandler = typeHandlersRegistered[typeName];
    extendedTypeHandler ??= typeHandlersRegistered[typeName.toLowerCase()];
    return extendedTypeHandler;
  }

  /// Returns a [ExtendedTypeHandler] by [typeID].
  static T getExtendedTypeHandlerByID<T extends ExtendedTypeHandler>(
      int typeID) {
    initialize();
    return typeHandlersRegisteredIDs[typeID];
  }

  /// Identify format [ExtendedTypeHandler].
  static ExtendedTypeHandler identifyTypeHandler(String value) {
    initialize();
    for (var handler in typeHandlersRegistered.values) {
      if (handler.matchesFormat(value)) {
        return handler;
      }
    }
    return null;
  }

  /// Identify format type name.
  static String identifyTypeName(String value) {
    var typeHandler = identifyTypeHandler(value);
    return typeHandler != null ? typeHandler.getTypeName() : null;
  }

  /// Identify format type ID.
  static int identifyTypeID(String value) {
    var typeHandler = identifyTypeHandler(value);
    return typeHandler != null ? typeHandler.getTypeID() : 0;
  }

  /// Parses to a [ExtendedType] with [typeName].
  static T fromByName<T extends ExtendedType>(String typeName, String value) {
    var typeHandler = getExtendedTypeHandlerByName(typeName);
    return typeHandler?.createInstance(value);
  }

  /// Parses to a [ExtendedType] with [typeID].
  static T fromByID<T extends ExtendedType>(int typeID, String value) {
    var typeHandler = getExtendedTypeHandlerByID(typeID);
    return typeHandler.createInstance(value);
  }

  /// Identifies format and parses to a [ExtendedType] instance.
  static T from<T extends ExtendedType>(String value) {
    var typeName = identifyTypeName(value);
    return fromByName(typeName, value);
  }

  /// The universal type name.
  String get typeName;

  /// The universal type ID.
  int get typeID;

  /// Encodes this instances as [String].
  String encodeAsString();

  List getParameters() => null;

  String getParametersLine() => null;

  bool equalsParameters(ExtendedType other) {
    if (other == null) return false;
    return isEqualsDeep(getParameters(), other.getParameters());
  }

  /// Returns [true] if [value] matches this instance type.
  bool matches(String value) {
    return encodeAsString() == value;
  }

  List<Operation> getOperations() => null;

  List<Operation> getAvailableOperations() => null;
}

/// Base classe for types handlers.
abstract class ExtendedTypeHandler<T extends ExtendedType> {
  /// Creates an instance of this type handler parsing [value].
  T createInstance(String value);

  /// Returns the type name.
  String getTypeName();

  /// Returns the type ID.
  int getTypeID();

  /// Returns [true] if [value] matches this instance type.
  bool matchesFormat(String value);
}

class Operation {
  final String name;

  final String description;

  final List<OperationParameter> _parameters;

  Operation(this.name, this.description, [this._parameters]);

  List<OperationParameter> get parameters => _parameters;

  OperationParameter getParameter(int index) =>
      _parameters != null ? _parameters[index] : null;

  int get parametersSize => _parameters != null ? _parameters.length : 0;

  bool get hasParameters => _parameters != null && _parameters.isNotEmpty;

  static List<String> splitParametersParts(String data) {
    if (data == null) return null;

    data = data.trim();
    return data.split(RegExp(r'\s*;\s*'));
  }

  List parseValues(String data) {
    if (data == null) return null;
    var parts = splitParametersParts(data);
    return parseValuesFromList(parts);
  }

  List parseValuesFromList(List<String> parts) {
    if (parts == null) return null;

    var values = [];

    for (var i = 0; i < values.length; i++) {
      var part = parts[i];
      var parameter = parameters[i];
      values[i] = parameter.parseValue(part);
    }

    return values;
  }

  @override
  String toString() {
    if (!hasParameters) return name;

    var str = StringBuffer();

    str.write(name);

    str.write('(');
    str.write(parameters.join(','));
    str.write(')');

    return str.toString();
  }
}

enum OperationParameterType { INT, FLOAT, STRING }

String getOperationParameterTypeName(OperationParameterType type) {
  switch (type) {
    case OperationParameterType.INT:
      return 'INT';
    case OperationParameterType.FLOAT:
      return 'FLOAT';
    case OperationParameterType.STRING:
      return 'STRING';
    default:
      return null;
  }
}

dynamic parseOperationParameterTypeValue(
    OperationParameterType type, String data) {
  data = data.trim();

  switch (type) {
    case OperationParameterType.INT:
      return parseInt(data);
    case OperationParameterType.FLOAT:
      return parseDouble(data);
    case OperationParameterType.STRING:
      return parseString(data);
    default:
      throw StateError("Can't parse value as type $typeΩ: $data");
  }
}

class OperationParameter {
  final OperationParameterType type;

  final String name;

  OperationParameter(this.type, this.name);

  T parseValue<T>(String data) {
    return parseOperationParameterTypeValue(type, data);
  }

  @override
  String toString() {
    return '${getOperationParameterTypeName(type)} $name';
  }
}

class OperationCall {
  final Operation operation;

  final List parametersValues;

  OperationCall(this.operation, this.parametersValues);

  String get name => operation.name;

  @override
  String toString() {
    return 'OperationCall{operation=$operation{${parametersValues != null ? ", parametersValues=$parametersValues" : ""}}';
  }
}

bool _registeredTypes = false;

void _registerTypes() {
  if (_registeredTypes) return;
  _registeredTypes = true;

  ETURL.initialize();
  ETDataBase64URL.initialize();
  ETEmail.initialize();
  ETEntityReference.initialize();
}
