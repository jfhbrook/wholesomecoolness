#!/usr/bin/env bash

for page in $(find public -name '*.html'); do
  python ./scripts/remove-analytics.py "${page}"
done
