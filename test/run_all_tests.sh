set -euo pipefail

export readonly TEST_DIR="${BASH_SOURCE%/*}"

readonly BATS_DIR="${TEST_DIR}/../tools/bats/bin"
readonly TEST_FILES="${TEST_DIR}/acceptance_tests/*.bats"

for filename in ${TEST_FILES}
do
    printf "\e[34mProcessing: %s\e[0m\n\n" "$filename"
    ${BATS_DIR}/bats "$filename"
    printf "\n"
done
