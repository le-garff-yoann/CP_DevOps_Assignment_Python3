# Solution

## `roles/tomcat-sample`

It is the central element around which this project is built. `defaults/` declares the default values of the variables of the role. Some will be mentioned all along this document.

The *tasks* of this role are divided into three files/parts detailed below.

### `tasks/prerequisites.yml`

This file groups the tasks installing the dependencies necessary for launching `pytest` and the Ansible `docker_*` modules (they depends on the Python library for the Docker Engine API).

These dependencies are, at the moment, only Python modules and they are installed with the Ansible `pip` module.

### `tasks/deploy.yml`

This file groups together the tasks which consist in building and starting the Docker image and the Docker container which hosts the "Tomcat Sample Application".

A first task builds the image via the use of the `docker_image` module on a` Dockerfile` located in `files/`.
This `Dockerfile` has several build args (`ARG`) used to determine:
- The base image to use (by default an [official image of Tomcat 9](https://hub.docker.com/_/tomcat)).
- The *war* file to download (by default the ["Tomcat Sample Application"](https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/)), its location (the `webapps/` directory of the Tomcat installation) as well as its `basename` which will determine the path on which the application will be exposed (by default */sample*).

The generated image will then be used to start a container (via the module `docker_container`) on the host with port published equal to 8080 by default.

`files/test_health.py` is finally launched a certain number of times until the availability of the application is confirmed. How this script works is explained further.

### `tasks/main.yml`

This file is responsible for launching:
- `tasks/prerequisites.yml` if `tomcat_sample_install_prereqs` is true.
- `tasks/deploy.yml` if `files/test_health.py` is in error.

### `files/test_health.py`

This script is used as a health check against a running "Tomcat Sample Application".

It requires the passage of two values ​​through environment variables:
- `PYTEST_BASE_URL`.
- `PYTEST_BODY_IN`.

It starts with `pycheck` and implements two tests:
- HTTP GET on `PYTEST_BASE_URL` must return with status code equal to 200.
- the character string `PYTEST_BODY_IN` must be present in the body of the response to an HTTP GET on `PYTEST_BASE_URL`.

### `molecule/`

This role is tested via [Molecule](https://molecule.readthedocs.io/en/2.22) against a Docker image generated in accordance with the content of `meta/`.
An idempotency test is part of the `default` scenario.

The launch of these tests is documented [here](README.md#via-molecule-and-docker).

## Playbooks

The `site.yml` playbook is the entry point for this project. He is responsible for launching the `tomcat-sample` role.

The `hosts` file is an example of inventory.

An example of the usage of these two together is documented [here](README.md#against-localhost).
