# simple_todo_list

A simple Flutter mobile project for creating and reminding to-do tasks
Author: Nguyen Khanh Hoang - 1712457

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to Generate Hive TypeAdapter

1. Install ``hive_generator`` and ``build_runner`` to dev_dependencies
2. To generate a TypeAdapter for a class, annotate it with @HiveType and provide a typeId (between 0 and 223)
3. Annotate all fields which should be stored with @HiveField
4. Run build task ``flutter packages pub run build_runner build``
5. Register the generated adapter