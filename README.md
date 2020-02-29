# CP DevOps Assignment Python3

[![pipeline status](https://gitlab.com/le-garff-yoann/CP_DevOps_Assignment_Python3/badges/master/pipeline.svg)](https://gitlab.com/le-garff-yoann/CP_DevOps_Assignment_Python3/pipelines)

Ansible roles and playbooks to make the ["Tomcat Sample Application"](https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/) "build and run" on Docker.

Please [come here for a more complete presentation](SOLUTION.md).

## Prerequisites

- `python3` (installed locally and on the targets (available in `$PATH` as `python3`)).
- `ansible` (installed locally and using `python3`).
- `sudo` (installed on the targets).
- `pip3` (installed on the targets).
- `bash` (installed on the targets).
- `docker` (installed and running on the targets).

**N.B**: The values of [`galaxy_info.platforms`](roles/tomcat-sample/meta/main.yml) and [`platforms.*.image`](roles/tomcat-sample/molecule/default/molecule.yml) corresponds to the platforms on which I carried out my tests.

## Testing

1. `git clone` this repository.
2. `cd` to it.

### Against `localhost`

```bash
ansible-playbook -Ki hosts -l localhost site.yml
```

### Via `molecule` and `docker`

```bash
sudo docker run --rm \
    -v "$(pwd):/t:ro" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    --privileged --cap-add SYS_ADMIN \
    registry.gitlab.com/le-garff-yoann/docker-molecule:2.22-2.9.5-1.0.2 \
    sh -c 'cd /t && . helpers.sh && roles_run_molecule test'
```
