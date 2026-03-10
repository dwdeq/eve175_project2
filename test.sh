#!/usr/bin/env bash
# test.sh
# Usage: ./test.sh

fail=0
pass=0

# Test 1: Normal filtering
cat > test.fq <<'EOF'
@read1
ATCGATCG
+
IIIIIIII
@read2
GGGGTTTT
+
!!!!!!!!
@read3
TTTTCCCC
+
FFFFFFFF
EOF

expected_out=$(cat <<'EOF'
@read1
ATCGATCG
+
IIIIIIII
@read3
TTTTCCCC
+
FFFFFFFF
EOF
)

out=$(./quality_filter.sh test.fq 30)
if [[ "$out" == "$expected_out" ]]; then
  echo "PASS: test fastq"
  ((pass++))
else
  echo "FAIL: test fastq"
  ((fail++))
fi

# Test 2: edge case: empty file should produce 0/0 and no output
echo '' > empty.fq
out=$(./quality_filter.sh empty.fq 30 2>&1)
if [[ "$out" == *"Reads before filtering: 0"* ]]; then
  echo "PASS: empty input"
  ((pass++))
else
  echo "FAIL: empty input"
  ((fail++))
fi

# Test 3: error case: missing arguments
if $(../quality_filter.sh 2>&1); then
  echo "FAIL: missing arguments should return error"
  ((fail++))
else
  echo "PASS: missing arguments"
  ((pass++))
fi

# Test 3: error case: missing arguments
if $(../quality_filter.sh test.fq 2>&1); then
  echo "FAIL: missing arguments should return error"
  ((fail++))
else
  echo "PASS: missing arguments"
  ((pass++))
fi

# Test 4: error case: non-integer min quality
if $(../quality_filter.sh test.fq abc 2>&1); then
  echo "FAIL: non-integer min quality should return error"
  ((fail++))
else
  echo "PASS: non-integer min quality"
  ((pass++))
fi

# Summary

echo "RESULT: $pass passed, $fail failed"
if [ "$fail" -ne 0 ]; then
  exit 1
fi

rm test.fq empty.fq
