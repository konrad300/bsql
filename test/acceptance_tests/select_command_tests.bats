setup() {
    readonly BSQL_PATH="${TEST_DIR}/../src/bsql"
    readonly UNRECOGNIZED_MESSAGE="Unrecognized syntax"
    readonly EXAMPLE_PATH="${TEST_DIR}/data_sets/small.csv"
    readonly HUGE_DATASET_PATH="${TEST_DIR}/data_sets/huge.csv"
}

# "select col1,col2 from example1.csv where col1>1"
# "select col1,col2 from example1.csv where col1=xxx"
# "select col1,col2 from example1.csv where col1!=abc"

@test "Given incorrect syntax With no *from* clause Should fail with message" {
    run "$BSQL_PATH" "select col1"
    [ "$output" = "$UNRECOGNIZED_MESSAGE" ]
    [ "$status" -eq 1 ]
}

@test "Given incorrect syntax With no filename Should fail with message" {
    run "$BSQL_PATH" "select col1 from"
    [ "$output" = "$UNRECOGNIZED_MESSAGE" ]
    [ "$status" -eq 1 ]
}

@test "Given correct syntax With missing column Should fail" {
    run "$BSQL_PATH" "select xyz,distance from ${EXAMPLE_PATH}"
    [ "$status" -eq 1 ]
}

@test "Given correct syntax With missing file Should fail" {
    run "$BSQL_PATH" "select co11 from nonexisting.csv"
    [ "$status" -eq 1 ]
}

@test "Given correct syntax With one column Should success" {
    run "$BSQL_PATH" "select distance from ${EXAMPLE_PATH}"
    echo "$output"
    [ "${lines[0]}" = "distance" ]
    [ "${lines[1]}" = "294" ]
    [ "${lines[2]}" = "215" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With all columns from file Should success" {
    run "$BSQL_PATH" "select from,to city,distance from ${EXAMPLE_PATH}"
    [ "${lines[0]}" = "from,to city,distance" ]
    [ "${lines[1]}" = "Warszawa,Krakow,294" ]
    [ "${lines[2]}" = "Krakow,Stalowa Wola,215" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With all columns using star Should success" {
    run "$BSQL_PATH" "select * from ${EXAMPLE_PATH}"
    [ "${lines[0]}" = "from,to city,distance" ]
    [ "${lines[1]}" = "Warszawa,Krakow,294" ]
    [ "${lines[2]}" = "Krakow,Stalowa Wola,215" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With all columns in reversed order Should success" {
    run "$BSQL_PATH" "select distance,to city,from from ${EXAMPLE_PATH}"
    [ "${lines[0]}" = "distance,to city,from" ]
    [ "${lines[1]}" = "294,Krakow,Warszawa" ]
    [ "${lines[2]}" = "215,Stalowa Wola,Krakow" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With column named *from* Should success" {
    run "$BSQL_PATH" "select from from ${EXAMPLE_PATH}"
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With mixed-case characters Should success" {
    run "$BSQL_PATH" "SeleCt DistaNce fRom ${EXAMPLE_PATH^}"
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With huge data set Should success" {
    run "$BSQL_PATH" "select cnt from ${HUGE_DATASET_PATH}"
    [ "${#lines[@]}" -eq 13963 ]
    [ "$status" -eq 0 ]
}
