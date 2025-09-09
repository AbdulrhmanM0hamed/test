import 'package:test/features/categories/domain/entities/department.dart';

abstract class DepartmentState {
  const DepartmentState();
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<Department> departments;

  const DepartmentLoaded({required this.departments});
}

class DepartmentError extends DepartmentState {
  final String message;

  const DepartmentError({required this.message});
}
