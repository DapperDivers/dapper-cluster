#!/usr/bin/env bash

kubectl delete pods --field-selector=status.phase==Failed -A

kubectl delete pod --field-selector=status.phase==Succeeded -A
