# OpenDXL Node-RED Docker
[![Docker Build Status](https://img.shields.io/docker/build/opendxl/opendxl-node-red-docker.svg)](https://hub.docker.com/r/opendxl/opendxl-node-red-docker/)

## Overview

This repository contains the files necessary to build a [Docker](https://www.docker.com/) image that consists of the
core [Node-RED](https://nodered.org/) installation along with a set of standard OpenDXL Node-RED extensions.

The Docker image exposes a volume that can be easily mapped via higher-level Docker interfaces (Kitematic, 
Docker Cloud, etc.). This supports the ability to persist Node-RED configuration data external to the Docker container, 
allowing for upgrades of the Docker image without the loss of configuration information.

The Docker image has SSL enabled by default (use ``https://``) and will generate a self-signed certificate if a key-pair is not found on 
startup.

The default administrator credentials used to login to the console are ``admin/password``. See the 
[Node-RED security page](https://nodered.org/docs/security#usernamepassword-based-authentication) for information on 
updating this password.

A pre-built version of this Docker image can be obtained via the 
[OpenDXL Node-RED Docker](https://hub.docker.com/r/opendxl/opendxl-node-red-docker/) registry on 
[DockerHub](https://hub.docker.com/).

## Bugs and Feedback

For bugs, questions and discussions please use the [GitHub Issues](https://github.com/opendxl/opendxl-node-red-docker/issues).

## LICENSE

Copyright 2018 McAfee, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with 
the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on 
an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.
