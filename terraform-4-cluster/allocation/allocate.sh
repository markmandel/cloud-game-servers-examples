#!/bin/bash

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

NAMESPACE=default
EXTERNAL_IP=`kubectl get services agones-allocator -n agones-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
CERT_FOLDER=$(pwd)/certs/$(kubectl config current-context)

cd ~/workspace/agones/src/agones.dev/agones/
go run examples/allocator-client/main.go --ip ${EXTERNAL_IP} \
    --namespace ${NAMESPACE} \
    --key "${CERT_FOLDER}/client.key" \
    --cert "${CERT_FOLDER}/client.crt" \
    --cacert "${CERT_FOLDER}/ca.crt" \
    --multicluster true
