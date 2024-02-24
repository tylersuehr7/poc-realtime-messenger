# PoC – Realtime Messenger

This project contains the source code for a proof-of-concept (PoC) realtime messaging system for iOS and Android applications.

Many other realtime messaging systems use a series of message queues and brokers with durability and persistence to facilitate / replicate messages to individual parties for the realtime communication. This approach works, obviously, and there's nothing wrong with doing so. However, this project takes a different approach. It uses a centralized database to store all messages associated with a particular chat and uses a temporary message queue to relay message events to any connected clients in realtime via WebSocket. Replaying message history is as simple as querying the messages table for a particular chat. 

## Required system dependencies
- Docker (latest)
- Python 3.11 (or higher)
- Flutter 3 (or higher)
- Make (latest)

## Project dependencies
- Django Framework
  - Used to build the PoC REST API and WebSocket API
- Django Channels
  - Used as the underlying mechanism for the WebSocket connection management
- SQLite
  - Used as the primary database for this PoC
- Redis
  - Used as the publish-subscribe mechanism for message events. Used by Django Channel Layer
- Xcode build tools
  - Used to build the Flutter application for iOS
- Android SDK
  - Used to build the Flutter application for Android

## Getting started
1. Start Docker and run Redis container
  - `$ docker run --rm -p 6379:6379 redis:7`

2. Start the REST API / WebSocket API server
  - `$ cd <project-source>/server   # cd into root of server source code`
  - `$ make setup-dev-environment   # Only for first-time setup`
  - `$ python3 manage.py runserver  # Start the server`

3. Update the Flutter application endpoint variables
  - This is just a PoC so I didn't take the time to organize configurable vars properly
  - Update REST API endpoint: `const String _serverEndpoint = "http://10.0.0.247:10000";`
  - Update WebSocket API endpoint: `const String _websocketEndpoint = "ws://10.0.0.247:10000";`

4. Run the Flutter application
  - `$ cd <project-source>/client  # cd into root of client source code`
  - `$ flutter pub get             # Get all required dependencies of Flutter project`
  - `$ flutter run                 # Start the Flutter application`

## Author
- [Tyler Suehr](https://www.linkedin.com/in/tyler-suehr/)

> Copyright © 2024 Tyler R. Suehr
