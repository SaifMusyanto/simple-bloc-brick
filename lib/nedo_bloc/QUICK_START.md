# Simple BLoC - Quick Start Guide

## Installation

1. **Install Mason CLI** (if not already installed):

```bash
dart pub global activate mason_cli
```

2. **Add the brick to your project**:

From local path:

```bash
cd your_flutter_project
mason add simple_bloc --path /path/to/simple_bloc_brick
```

Or from git (after publishing):

```bash
mason add simple_bloc --git-url https://github.com/yourusername/simple_bloc_brick
```

## Generate Your First BLoC

Navigate to where you want to generate the files:

```bash
cd lib/features/user/presentation/bloc
```

Run the generator:

```bash
mason make simple_bloc
```

Answer the prompts:

```
? What is the feature name? user
? What is the data type? List<User>
? What is the datasource class name? UserDatasource
? What is the datasource fetch method name? getUsers
? Use Equatable? Yes
```

Done! You now have:

- ✅ `user_bloc.dart`
- ✅ `user_event.dart`
- ✅ `user_state.dart`

## Create the Datasource

The generated BLoC expects a datasource. Create it:

```dart
// lib/features/user/data/datasources/user_datasource.dart

abstract class UserDatasource {
  Future<List<User>> getUsers();
}

class UserDatasourceImpl implements UserDatasource {
  final http.Client client;

  UserDatasourceImpl(this.client);

  @override
  Future<List<User>> getUsers() async {
    final response = await client.get(
      Uri.parse('https://api.example.com/users'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
```

## Use in Your App

### 1. Provide the BLoC

```dart
BlocProvider(
  create: (context) => UserBloc(
    datasource: UserDatasourceImpl(http.Client()),
  )..add(const FetchUser()),
  child: UserPage(),
)
```

### 2. Build UI based on states

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.data[index].name),
                );
              },
            );
          }

          if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return Center(child: Text('Press button to load'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(const FetchUser());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

## Tips

1. **Generate files in the correct location**:

   ```
   lib/features/[feature]/presentation/bloc/
   ```

2. **Create datasource first** (or at least the interface) so you know the method names

3. **Use dependency injection** for datasource (get_it, provider, etc.)

4. **Add more events/states** after generation as needed

5. **Test your BLoC**:
   ```dart
   test('emits [Loading, Loaded] when fetch succeeds', () {
     // arrange
     when(() => datasource.getUsers()).thenAnswer((_) async => [user]);

     // assert
     expectLater(
       bloc.stream,
       emitsInOrder([
         UserLoading(),
         UserLoaded([user]),
       ]),
     );

     // act
     bloc.add(FetchUser());
   });
   ```

## Troubleshooting

**Issue**: "Cannot find datasource class"

- Make sure you've created the datasource class first
- Check the import statement in the generated bloc file

**Issue**: "Type mismatch error"

- Verify the data type you specified matches what datasource returns
- Example: If datasource returns `Future<List<User>>`, specify `List<User>` as data type

**Issue**: "Equatable not found"

- Add to pubspec.yaml: `equatable: ^2.0.0`
- Or generate without Equatable by answering "No" to the prompt

## Next Steps

After mastering v1.0, look forward to:

- v2.0: Multiple event types (delete, update, create)
- v3.0: Repository layer generation
- v4.0: Complete feature generation (data + domain + presentation)

Happy coding! 🚀
