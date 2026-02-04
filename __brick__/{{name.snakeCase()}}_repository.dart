{{#use_repository}}
abstract class {{name.pascalCase()}}Repository {
  /// Mengambil data {{name}}
  Future<{{{data_type}}}> get{{name.pascalCase()}}s();

  /// Menambah data {{name}}
  Future<void> create{{name.pascalCase()}}({{{data_type}}} data);

  /// Mengubah data {{name}}
  Future<void> update{{name.pascalCase()}}({{{data_type}}} data);

  /// Menghapus data {{name}} berdasarkan ID
  Future<void> delete{{name.pascalCase()}}(String id);
}

class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  final {{{datasource_name}}} _datasource;
  
  {{name.pascalCase()}}RepositoryImpl(this._datasource);
  
  @override
  Future<{{{data_type}}}> get{{name.pascalCase()}}s() async {
    try {
      return await _datasource.get{{name.pascalCase()}}s();
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> create{{name.pascalCase()}}({{{data_type}}} data) async {
    try {
      await _datasource.create{{name.pascalCase()}}(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> update{{name.pascalCase()}}({{{data_type}}} data) async {
    try {
      await _datasource.update{{name.pascalCase()}}(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> delete{{name.pascalCase()}}(String id) async {
    try {
      await _datasource.delete{{name.pascalCase()}}(id);
    } catch (e) {
      rethrow;
    }
  }
}
{{/use_repository}}