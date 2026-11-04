#!/bin/bash
# override locally with: export PSQL="docker compose exec -T pg psql"
PSQL=${PSQL:-psql}

mkdir -p results
for problem in sql/*; do
    printf "$problem "
    problem_id=$(basename ${problem%.sql})
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"
    $PSQL < $problem > $result 2>&1
    DIFF=$(diff -B $expected $result)
    if [ -z "$DIFF" ]; then
        echo pass
    else
        echo fail
        echo "===== $problem ====="
        cat $problem
        echo "===== diff (< expected, > yours) ====="
        echo "$DIFF" | head -n 60
        exit 2
    fi
done
