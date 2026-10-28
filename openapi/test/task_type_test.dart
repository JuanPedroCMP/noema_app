import 'package:test/test.dart';
import 'package:openapi/openapi.dart';
import 'package:built_value/serializer.dart';

// tests for TaskType
void main() {

  group(TaskType, () {
    test('serializes generate_node_description', () {
      final task = serializers.deserialize(
        'generate_node_description',
        specifiedType: const FullType(TaskType),
      );

      expect(task, TaskType.generateNodeDescription);
      expect(
        serializers.serialize(
          TaskType.generateNodeDescription,
          specifiedType: const FullType(TaskType),
        ),
        'generate_node_description',
      );
    });
  });
}
