#!/bin/bash
curl -s http://localhost:3000 > /dev/null

if [ $? -eq 0 ]; then
    echo "SMOKE TEST PASSED"
    exit 0
else
    echo "SMOKE TEST FAILED"
    exit 1
fi
