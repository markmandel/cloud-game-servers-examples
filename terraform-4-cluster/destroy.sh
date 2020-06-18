#!/usr/bin/env bash

# Copyright 2020 Google LLC All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

#
# Since deleting a cluster with resources in it can leave behind orphaned resources
# such as load balancers, here's a short script to delete helm installations
# before deleting the infrastructure.
#

# Assuming Helm 2.x at this point, but run upgrade in case local version isn't the same as the Terraform version
upgrade_helm() {
  gcloud container clusters get-credentials $1 --zone $2
  helm init --upgrade
}

delete_helm() {
  gcloud container clusters get-credentials $1 --zone $2
  helm delete --purge agones
}

gcloud container clusters list --format="value(name,zone)" | grep game-cluster | while read -r line ; do
    upgrade_helm $line
done

echo "Helm upgrade complete, waiting for a minute to finalise..."
sleep 60

gcloud container clusters list --format="value(name,zone)" | grep game-cluster | while read -r line ; do
    delete_helm $line
done

terraform destroy
