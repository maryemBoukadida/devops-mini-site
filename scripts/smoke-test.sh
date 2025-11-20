#!/bin/bash
# smoke-test.sh dans le dossier scripts/

# Test simple de la page
curl -s http://localhost:3000 > /dev/null

if [ $? -eq 0 ]; then
    echo "PASSED" | tee smoke_result.txt
    exit 0
else
    echo "FAILED" | tee smoke_result.txt
    exit 1
fi
