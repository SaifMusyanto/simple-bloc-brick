# Nedo BLoC

A Mason brick to generate BLoC pattern boilerplate with basic states and fetch event.

## Features

- ✅ Generates 4 basic states: `Initial`, `Loading`, `Loaded`, `Error`
- ✅ Generates 1 fetch event
- ✅ Generates BLoC with complete fetch implementation
- ✅ Supports Equatable (optional)
- ✅ Clean, production-ready code
- ✅ Follows BLoC best practices

## Installation

### Install Mason

```bash
dart pub global activate mason_cli
```

### Globally

```bash
mason add nedo_bloc
```

### Locally

```bash
mason add nedo_bloc --path C:\Users\ASUS\OneDrive\Documents\Exploration\simple_bloc_brick
```

## Usage

### Generate BLoC files

```bash
mason make nedo_bloc
```

You'll be prompted for:

1. **Feature name** (e.g., `user`, `product`, `post`)
2. **Data type** (e.g., `List<User>`, `Product`, `Map<String, dynamic>`)
3. **Datasource class name** (e.g., `UserDatasource`, `ProductRemoteDatasource`)
4. **Datasource method name** (e.g., `getUsers`, `fetchProducts`)
5. **Use Equatable?** (default: `true`)

### Example

```bash
$ mason make nedo_bloc

? What is the feature name? user
? What is the data type? List<User>
? What is the datasource class name? UserDatasource
? What is the datasource fetch method name? getUsers
? Use Equatable? Yes
```

This will generate:

```
lib/
├── user_bloc.dart
├── user_event.dart
└── user_state.dart
```

## Generated Code Example

### user_state.dart

```dart
import 'package:equatable/equatable.dart';

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<User> data;

  const UserLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
```

### user_event.dart

```dart
import 'package:equatable/equatable.dart';

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {
  const FetchUser();
}
```

### user_bloc.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserDatasource datasource;

  UserBloc({
    required this.datasource,
  }) : super(const UserInitial()) {
    on<FetchUser>(_onFetchUser);
  }

  Future<void> _onFetchUser(
    FetchUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final data = await datasource.getUsers();
      emit(UserLoaded(data));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

## Usage in Flutter App

```dart
// 1. Provide the BLoC
BlocProvider(
  create: (context) => UserBloc(
    datasource: context.read<UserDatasource>(),
  )..add(const FetchUser()),
  child: UserPage(),
)

// 2. Listen to states
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserInitial) {
      return const Center(child: Text('Press button to load'));
    }

    if (state is UserLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UserLoaded) {
      return ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, index) {
          final user = state.data[index];
          return ListTile(title: Text(user.name));
        },
      );
    }

    if (state is UserError) {
      return Center(child: Text('Error: ${state.message}'));
    }

    return const SizedBox();
  },
)

// 3. Dispatch events
context.read<UserBloc>().add(const FetchUser());
```

## Prerequisites

Your project should have these dependencies:

```yaml
dependencies:
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0 # if use_equatable = true
```

## Project Structure Recommendation

```
lib/
├── features/
│   └── user/
│       ├── data/
│       │   └── datasources/
│       │       └── user_datasource.dart  # You create this
│       └── presentation/
│           └── bloc/
│               ├── user_bloc.dart        # Generated
│               ├── user_event.dart       # Generated
│               └── user_state.dart       # Generated
```

## Customization

After generation, you can:

- Add more events to `user_event.dart`
- Add more states to `user_state.dart`
- Add event handlers in `user_bloc.dart`
- Modify error handling logic
- Add logging, analytics, etc.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License

## Author

Saif Musyanto - [saifmusyanto@gmail.com](mailto:saifmusyanto@gmail.com)
