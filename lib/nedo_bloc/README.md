# Nedo BLoC

🚀 **Full-featured BLoC generator with interactive CLI, multiple events, custom states, and repository layer support.**

## Features

✅ **Multiple Event Types**

- Fetch
- Create
- Update
- Delete
- Refresh

✅ **Configurable States**

- Standard: Initial, Loading, Loaded, Error
- Optional: Empty, Creating, Updating, Deleting

✅ **Repository Layer** (Optional)

- Clean architecture separation
- Easy to mock for testing
- Centralized error handling

✅ **Interactive CLI**

- Step-by-step prompts
- Or use command-line flags
- Smart defaults

✅ **Flexible**

- With/without Equatable
- With/without Repository
- Mix and match events
- Custom method names

## Installation

```bash
mason add advanced_bloc --path /path/to/advanced_bloc_brick
```

## Quick Start

### Basic Usage (Interactive)

```bash
mason add nedo_bloc
```

Answer the prompts:

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
? Generate repository layer? (Y/n) n
? What is the data type? (dynamic) List<User>
? Datasource class name? UserDatasource
? Include fetch event? (Y/n) Y
? Include create event? (Y/n) Y
? Include update event? (Y/n) Y
? Include delete event? (Y/n) Y
? Include refresh event? (Y/n) n
? Include Empty state? (Y/n) Y
? Include Deleting state? (Y/n) Y
? Include Creating state? (Y/n) Y
? Include Updating state? (Y/n) Y
? Use Equatable? (Y/n) Y
? Fetch method name? (getUsers)
? Create method name? (createUser)
? Update method name? (updateUser)
? Delete method name? (deleteUser)
```

### Using Command Line Flags

```bash
mason make advanced_bloc \
  --name user \
  --data_type "List<User>" \
  --datasource_name UserDatasource \
  --include_fetch \
  --include_create \
  --include_update \
  --include_delete \
  --include_empty_state \
  --include_creating_state \
  --include_updating_state \
  --include_deleting_state \
  --use_equatable
```

## Examples

### Example 1: Full CRUD with Repository

```bash
mason make advanced_bloc \
  --name product \
  --use_repository \
  --data_type "Product" \
  --datasource_name ProductDatasource \
  --include_fetch \
  --include_create \
  --include_update \
  --include_delete \
  --include_creating_state \
  --include_updating_state \
  --include_deleting_state
```

**Generates:**

- `product_bloc.dart` - BLoC with 4 events
- `product_event.dart` - Fetch, Create, Update, Delete events
- `product_state.dart` - Initial, Loading, Loaded, Error, Creating, Updating, Deleting states
- `product_repository.dart` - Repository interface and implementation

### Example 2: Simple Fetch Only

```bash
mason make advanced_bloc \
  --name post \
  --data_type "List<Post>" \
  --datasource_name PostDatasource \
  --include_fetch \
  --include_empty_state
```

**Generates:**

- `post_bloc.dart` - BLoC with fetch event
- `post_event.dart` - Fetch event only
- `post_state.dart` - Initial, Loading, Loaded, Error, Empty states

### Example 3: With Repository Layer

```bash
mason make advanced_bloc \
  --name comment \
  --use_repository \
  --data_type "List<Comment>" \
  --datasource_name CommentDatasource \
  --include_fetch \
  --include_create \
  --include_delete
```

**Generates:**

- `comment_bloc.dart` - Uses repository instead of datasource
- `comment_event.dart` - Fetch, Create, Delete events
- `comment_state.dart` - Standard states
- `comment_repository.dart` - Repository layer

## Configuration Options

### Events

| Flag                | Description            | Default |
| ------------------- | ---------------------- | ------- |
| `--include_fetch`   | Generate fetch event   | `true`  |
| `--include_create`  | Generate create event  | `false` |
| `--include_update`  | Generate update event  | `false` |
| `--include_delete`  | Generate delete event  | `false` |
| `--include_refresh` | Generate refresh event | `false` |

### States

| Flag                       | Description        | Default |
| -------------------------- | ------------------ | ------- |
| `--include_empty_state`    | Add Empty state    | `false` |
| `--include_creating_state` | Add Creating state | `false` |
| `--include_updating_state` | Add Updating state | `false` |
| `--include_deleting_state` | Add Deleting state | `false` |

### Architecture

| Flag               | Description               | Default |
| ------------------ | ------------------------- | ------- |
| `--use_repository` | Generate repository layer | `false` |
| `--use_equatable`  | Use Equatable             | `true`  |

### Method Names

| Flag              | Description        | Default        |
| ----------------- | ------------------ | -------------- |
| `--fetch_method`  | Fetch method name  | `get{Name}s`   |
| `--create_method` | Create method name | `create{Name}` |
| `--update_method` | Update method name | `update{Name}` |
| `--delete_method` | Delete method name | `delete{Name}` |

## Generated Code Structure

### Without Repository

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserDatasource datasource;

  UserBloc({required this.datasource}) : super(const UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  // Event handlers...
}
```

### With Repository

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(const UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  // Event handlers...
}

// Repository
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> createUser(User data);
  Future<void> updateUser(User data);
  Future<void> deleteUser(String id);
}
```

## Event Handlers

Each event generates a complete handler:

### Fetch Event

```dart
Future<void> _onFetchUser(
  FetchUser event,
  Emitter<UserState> emit,
) async {
  emit(const UserLoading());

  try {
    final data = await datasource.getUsers();

    if (data.isEmpty) {  // if include_empty_state
      emit(const UserEmpty());
    } else {
      emit(UserLoaded(data));
    }
  } catch (e) {
    emit(UserError(e.toString()));
  }
}
```

### Create Event

```dart
Future<void> _onCreateUser(
  CreateUser event,
  Emitter<UserState> emit,
) async {
  emit(const UserCreating());  // if include_creating_state

  try {
    await datasource.createUser(event.data);
    add(const FetchUser());  // Auto-refresh
  } catch (e) {
    emit(UserError(e.toString()));
  }
}
```

### Delete Event

```dart
Future<void> _onDeleteUser(
  DeleteUser event,
  Emitter<UserState> emit,
) async {
  emit(const UserDeleting());  // if include_deleting_state

  try {
    await datasource.deleteUser(event.id);
    add(const FetchUser());  // Auto-refresh
  } catch (e) {
    emit(UserError(e.toString()));
  }
}
```

## Smart Features

### Auto-Refresh After Mutations

Create/Update/Delete events automatically trigger a fetch:

```dart
// After create
await datasource.createUser(event.data);
add(const FetchUser());  // ← Auto-refresh
```

### Empty State Detection

When `include_empty_state` is enabled:

```dart
if (data == null || (data is List && data.isEmpty)) {
  emit(const UserEmpty());
} else {
  emit(UserLoaded(data));
}
```

### Specific Loading States

Each operation can have its own loading state:

- `Creating` for create
- `Updating` for update
- `Deleting` for delete
- `Loading` for fetch/refresh

## Usage in App

### Without Repository

```dart
BlocProvider(
  create: (context) => UserBloc(
    datasource: UserDatasourceImpl(),
  )..add(const FetchUser()),
  child: UserPage(),
)
```

### With Repository

```dart
BlocProvider(
  create: (context) => UserBloc(
    repository: UserRepositoryImpl(
      UserDatasourceImpl(),
    ),
  )..add(const FetchUser()),
  child: UserPage(),
)
```

### Handling Events

```dart
// Fetch
context.read<UserBloc>().add(const FetchUser());

// Create
context.read<UserBloc>().add(CreateUser(newUser));

// Update
context.read<UserBloc>().add(UpdateUser(updatedUser));

// Delete
context.read<UserBloc>().add(DeleteUser('user-id-123'));

// Refresh
context.read<UserBloc>().add(const RefreshUser());
```

### Handling States

```dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserLoading) {
      return const CircularProgressIndicator();
    }

    if (state is UserCreating) {
      return const Text('Creating user...');
    }

    if (state is UserDeleting) {
      return const Text('Deleting user...');
    }

    if (state is UserEmpty) {
      return const Text('No users found');
    }

    if (state is UserLoaded) {
      return ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, index) {
          final user = state.data[index];
          return UserTile(user: user);
        },
      );
    }

    if (state is UserError) {
      return Text('Error: ${state.message}');
    }

    return const SizedBox();
  },
)
```

## Best Practices

1. **Use repository for complex apps**
   - Better separation of concerns
   - Easier to test
   - Centralized error handling

2. **Include Empty state for lists**
   - Better UX
   - Clear distinction between loading and no data

3. **Use specific loading states for mutations**
   - Better UX feedback
   - Users know what's happening

4. **Auto-refresh after mutations**
   - Already built-in
   - Ensures UI stays in sync

## Comparison with Simple BLoC (v1.0)

| Feature        | Simple BLoC v1.0 | Advanced BLoC v2.0                     |
| -------------- | ---------------- | -------------------------------------- |
| Events         | Fetch only       | Fetch, Create, Update, Delete, Refresh |
| States         | 4 basic          | 4 basic + 4 optional custom            |
| Repository     | ❌               | ✅ Optional                            |
| Interactive    | Basic            | Full interactive CLI                   |
| Auto-refresh   | ❌               | ✅ After mutations                     |
| Empty state    | ❌               | ✅ Optional                            |
| Custom loading | ❌               | ✅ Per operation                       |

## Migration from v1.0

If you have v1.0 brick installed:

```bash
# Add v2.0 alongside v1.0
mason add advanced_bloc --path /path/to/advanced_bloc_brick

# Use v1.0 for simple cases
mason make simple_bloc

# Use v2.0 for complex cases
mason make advanced_bloc
```

## Troubleshooting

See the main [TROUBLESHOOTING.md](../simple_bloc_brick/TROUBLESHOOTING.md) for boolean flag issues.

**Quick tips:**

- Answer with `Y` or `n` (single letter) for boolean prompts
- Or use `--flag` for true, `--no-flag` or `--flag false` for false
- Generated files should have no errors (templates will show "errors")

## Contributing

Ideas for v4.0:

- Pagination support
- Infinite scroll
- Offline support
- Websocket integration
- GraphQL support

Submit your ideas and PRs!

## License

MIT License - See LICENSE file

---

**Happy coding!** 🎉

Version: 3.0.0  
Last Updated: 2026-02-02
