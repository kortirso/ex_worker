# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.1.6] - 2019-02-14
### Modified
- when terminated server then active messages reset to failed

## [0.1.5] - 2019-02-13
### Added
- check aliveness for message server
- handle server terminating with cleaning message servers

### Modified
- code refactoring

## [0.1.4] - 2019-02-13
### Added
- test

### Modified
- documentation

## [0.1.3] - 2019-02-13
### Added
- CHANGELOG
- Server module with functions for get and send message
- Supervision tree
- MessageServer for sending, receive result in Server
- MnesiaDB support by Memento
- uploading incompleted messages at the start
