#!/bin/bash
set -e

jscpd --min-lines 3 --min-tokens 25 --threshold 0 --gitignore --ignore "**/*.xml,**/*.json"
flutter analyze
flutter test --coverage
flutter pub run test_cov_console

RED='\033[0;31m'
NC='\033[0m'
flutter pub run test_cov_console -c
if grep -q "no unit test" coverage/test_cov_console.csv; then
  echo -e "${RED}Some files aren't covered${NC}"
  exit 1
fi

export "IFS=,"
read label br fn li un <<< $(grep "All files" coverage/test_cov_console.csv)
echo "branch " $br "func " $fn "line " $li
if (( $(echo "$br < 100" | bc -l) )) || (( $(echo "$fn < 100" | bc -l) )) || (( $(echo "$li < 100" | bc -l) )); then
  echo -e "${RED}Low coverage${NC}"
  exit 1
fi
echo Check Complete :\)
