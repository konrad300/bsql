setup() {
    readonly BSQL_PATH="${TEST_DIR}/../src/bsql"
    readonly EXAMPLE_PATH="${TEST_DIR}/data_sets/small.csv"
}

@test "Given correct syntax With csv formatter selected Should success" {
    run "$BSQL_PATH" -o csv "select * from ${EXAMPLE_PATH}"
    [ "${lines[0]}" = "from,to city,distance" ]
    [ "${lines[1]}" = "Warszawa,Krakow,294" ]
    [ "${lines[2]}" = "Krakow,Stalowa Wola,215" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With tsv formatter selected Should success" {
    run "$BSQL_PATH" -o tsv "select * from ${EXAMPLE_PATH}"
    [ "${lines[0]}" = "from	to city	distance" ]
    [ "${lines[1]}" = "Warszawa	Krakow	294" ]
    [ "${lines[2]}" = "Krakow	Stalowa Wola	215" ]
    [ "$status" -eq 0 ]
}

@test "Given correct syntax With html formatter selected Should success" {
    run "$BSQL_PATH" -o html "select * from ${EXAMPLE_PATH}"
    [ "${lines[0]}"  = "<table>" ]
    [ "${lines[1]}"  = "<tr>" ]
    [ "${lines[2]}"  = "    <th>from</th>" ]
    [ "${lines[3]}"  = "    <th>to city</th>" ]
    [ "${lines[4]}"  = "    <th>distance</th>" ]
    [ "${lines[5]}"  = "</tr>" ]
    [ "${lines[6]}"  = "<tr>" ]
    [ "${lines[7]}"  = "    <td>Warszawa</td>" ]
    [ "${lines[8]}"  = "    <td>Krakow</td>" ]
    [ "${lines[9]}"  = "    <td>294</td>" ]
    [ "${lines[10]}" = "</tr>" ]
    [ "${lines[11]}" = "<tr>" ]
    [ "${lines[12]}" = "    <td>Krakow</td>" ]
    [ "${lines[13]}" = "    <td>Stalowa Wola</td>" ]
    [ "${lines[14]}" = "    <td>215</td>" ]
    [ "${lines[15]}" = "</tr>" ]
    [ "${lines[16]}" = "</table>" ]
    [ "$status" -eq 0 ]
}
