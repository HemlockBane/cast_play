<a href="https://github.com/HemlockBane/cast_play/actions"><img src="https://github.com/HemlockBane/cast_play/workflows/Run Tests/badge.svg" alt="Build Status"></a>

## Overview

Cast Play is a podcast management app built with Flutter.

## Features
Its features include:
- Searching for podcasts.
- Viewing podcast details.
- Playing podcasts episodes(audio & video).
- Subscribing to podcasts and getting notifications when there are new episodes.
- Downloading podcast episodes and playing them offline.

## Screenshots
- WIP

## Getting Started
- WIP

## Architecture & Folder Structure
This app uses a combination of the architecture guidelines in a [guide to app architecture](https://developer.android.com/topic/architecture) and a feature-first project approach to structuring the project.

Each feature should normally have at least two layers:
- The UI layer
- The data layer

An optional layer called the domain layer can sit between the UI layer and the data layer to simplify and reuse the interactions between them.

The UI layer is responsible for displaying application data on the screen. It consists of:
- The view layer (screens and widgets)
- The state holder layer: The state holder processes ui events and exposes immutable state to the view. This app uses Bloc for state management

The data layer drives the features in the app. It is responsible for handling data operations and exposing data to the layers above it. It consists of:
- The repository layer
- The datasource layer
- The model layer


## Dependency Injection:
- This app uses [Injectable](https://pub.dev/packages/injectable) to manage its dependencies

## Testing & CI/CD
- WIP

## Copyright
- WIP
