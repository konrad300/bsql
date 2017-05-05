setup() {
    readonly BSQL_PATH="${TEST_DIR}/../src/bsql"
    readonly HELP_PAGE_HEADER="usage:"
    readonly INVALID_OPTION_MESSAGE="Invalid option"
}

@test "Given no options Should success quietly" {
    run "$BSQL_PATH"
    [ "$output" = "" ]
    [ "$status" -eq 0 ]
}

@test "Given unrecognized option Should fail with message" {
    run "$BSQL_PATH" -x
    [[ "$output" =~ "$INVALID_OPTION_MESSAGE" ]]
    [ "$status" -eq 1 ]
}

@test "Given -H option Should fail with message" {
    run "$BSQL_PATH" "-H"
    [[ "$output" =~ "$INVALID_OPTION_MESSAGE" ]]
    [ "$status" -eq 1 ]
}

@test "Given long help option Should success and display help page" {
    run "$BSQL_PATH" --help
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given long help option With white chars Should success and display help page" {
    run "$BSQL_PATH" 	  	--help 
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given long help option With quotation marks Should success and display help page" {
    run "$BSQL_PATH" "--help"
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given long help option With mixed chars Should success and display help page" {
    run "$BSQL_PATH" "--HelP"
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given short help option Should success and display help page" {
    run "$BSQL_PATH" -h
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given short help option With white chars Should success and display help page" {
    run "$BSQL_PATH" 	 	-h 
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}

@test "Given short help option With quotation marks Should success and display help page" {
    run "$BSQL_PATH" "-h"
    [[ "$output" =~ "$HELP_PAGE_HEADER" ]]
    [ "$status" -eq 0 ]
}
