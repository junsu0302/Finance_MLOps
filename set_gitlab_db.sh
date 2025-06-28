#!/bin/bash

yes yes | docker compose exec -T gitlab /bin/bash -c "gitlab-rake gitlab:setup"
