#!/bin/bash
set -e
RED='\033[0;31m'
NC='\033[0m'

jscpd --min-lines 3 --min-tokens 50 --threshold 0 --gitignore --ignore "**/*.xml,**/*.json"
flutter analyze
flutter test --coverage
flutter pub run test_cov_console

if (( $(echo "$(wc -l < lib/main.dart) > 7" | bc -l) )); then
  echo -e "${RED}main.dart has more than 7 lines${NC}. It is not covered so keep it small."
  exit 1
fi

flutter pub run test_cov_console -c
if grep -v main.dart coverage/test_cov_console.csv | grep -q "no unit test"; then
  echo -e "${RED}Some files aren't covered${NC}"
  exit 1
fi

export "IFS=,"
read label br fn li un <<< $(grep "All files" coverage/test_cov_console.csv)
if (( $(echo "$br < 100" | bc -l) )) || (( $(echo "$fn < 100" | bc -l) )) || (( $(echo "$li < 100" | bc -l) )); then
  echo -e "${RED}Go for full coverage${NC} - you can do it (all except main.dart)"
  exit 1
fi
echo Check Complete :\)
