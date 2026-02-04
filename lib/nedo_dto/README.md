# Nedo Dto

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A Mason brick to generate Dart models from Swagger/OpenAPI JSON schemas.

## Features

- **URL Support**: Fetch schemas directly from a URL.
- **Component Targeting**: Target specific components to generate only necessary models and their dependencies.
- **JSON Parsing**: Uses robust JSON decoding instead of YAML.
- **Dependency Resolution**: Automatically finds and generates nested models referenced by `$ref`.
- **Multi-File Output**: Generates a separate Dart file for each model.
- **Serialization**: Includes `fromMap`, `toMap`, `fromJson`, `toJson`.

## Usage 🚀

### Variables

| Variable           | Description                                                                                                                                                                                                | Default  |
| :----------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| `schema_url`       | URL to the Swagger/OpenAPI JSON file (e.g., `https://api.example.com/swagger/v1/swagger.json`). Supports URL fragments to target specific components (e.g. `.../swagger.json#/components/schemas/MyModel`) | Required |
| `target_component` | (Optional) Comma-separated list of component names to generate. If provided separately from URL fragment.                                                                                                  | `""`     |

### Running the Brick

```bash
mason make nedo_dto --schema_url "https://api.example.com/swagger.json"
```

### Targeting Specific Components

You can target a component via the URL fragment:

```bash
mason make nedo_dto --schema_url "https://api.example.com/swagger.json#/components/schemas/AuthResponse"
```

Or via the variable:

```bash
mason make nedo_dto --schema_url "https://api.example.com/swagger.json" --target_component "AuthResponse,User"
```

## Outputs

This brick generates Dart files in the current directory (or target output directory). Each model will have its own file (snake_cased based on the model name).

Example: `AuthResponse` -> `auth_response.dart`

_Created by [Akbar][1] 🧱_

[1]: https://github.com/mochalifakbar
