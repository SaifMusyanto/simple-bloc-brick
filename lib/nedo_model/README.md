# Nedo Model

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A comprehensive Mason brick to generate Clean Architecture compliant Dart components (Models, Entities, and Mappers) from Swagger/OpenAPI JSON schemas.

## Features

- **Clean Architecture Support**: Generates code for Data, Domain, and Mapper layers.
  - **Data Layer**: DTOs/Models with `fromJson`/`toJson`.
  - **Domain Layer**: Pure Entities and Params (renamed from Request).
  - **Mapper Layer**: Bidirectional extension methods (`toEntity`, `toModel`).
- **Smart Naming Conventions**:
  - `Request` objects renamed to `Params` in Domain.
  - `BaseRequest` suffix automatically stripped.
  - `Data`/`DTO` suffixes mapped to `Entity`.
- **URL Support**: Fetch schemas directly from a URL.
- **Component Targeting**: Target specific components to generate only necessary models and their dependencies.
- **Improved Resolution**: Better handling of nested object dependencies and recursive imports.
- **Serialization**: Includes `fromMap`, `toMap`, `fromJson`, `toJson` for Data models.

## Usage 🚀

### Variables

| Variable           | Description                                                                                                                                                                                                | Default  |
| :----------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| `schema_url`       | URL to the Swagger/OpenAPI JSON file (e.g., `https://api.example.com/swagger/v1/swagger.json`). Supports URL fragments to target specific components (e.g. `.../swagger.json#/components/schemas/MyModel`) | Required |
| `target_component` | (Optional) Comma-separated list of component names to generate. If provided separately from URL fragment.                                                                                                  | `""`     |

### Running the Brick

```bash
mason make nedo_model --schema_url "https://api.example.com/swagger.json"
```

### Targeting Specific Components

You can target a component via the URL fragment:

```bash
mason make nedo_model --schema_url "https://api.example.com/swagger.json#/components/schemas/AuthResponse"
```

Or via the variable:

```bash
mason make nedo_model --schema_url "https://api.example.com/swagger.json" --target_component "AuthResponse,User"
```

## Outputs

This brick generates Dart files organized by layer (Data, Domain, Mapper).

_Created by [Akbar][1] 🧱_

[1]: https://github.com/mochalifakbar
