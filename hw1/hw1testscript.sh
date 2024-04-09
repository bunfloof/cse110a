#!/bin/bash
# chmod +x hw1testscript.sh
# This student made test script may contain errors and does not guarantee correctness.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
project_dir="$(dirname "$script_dir")"
directories=()

if [[ "$script_dir" == *"part"* ]]; then
    directories+=("$script_dir" "$project_dir/part1" "$project_dir/part2" "$project_dir/part3" "$project_dir/part4")
elif [[ "$script_dir" == *"tests"* ]]; then
    directories+=("$project_dir/part1" "$project_dir/part2" "$project_dir/part3" "$project_dir/part4" "$project_dir")
else
    directories+=("$script_dir/part1" "$script_dir/part2" "$script_dir/part3" "$script_dir/part4" "$script_dir")
fi

# I don't care where you put this script
find_file() {
    local file="$1"
    for dir in "${directories[@]}"; do
        if [ -f "$dir/$file" ]; then
            echo "$dir/$file"
            return
        fi
    done
    echo ""
}

naive_scanner_path=$(find_file "NaiveScanner.py")
em_scanner_path=$(find_file "EMScanner.py")
sos_scanner_path=$(find_file "SOSScanner.py")
ng_scanner_path=$(find_file "NGScanner.py")

# st start

scanner=""
input_string=""

while getopts s:i: flag; do
    case "${flag}" in
    s) scanner=${OPTARG} ;;
    i) input_string=${OPTARG} ;;
    esac
done

servertest() {
    local test_name=$input_string
    server_response=$(curl -s -X POST "https://rp.ucsc.gay/scan" \
        -H "Content-Type: application/json" \
        -d "{\"scanner\": \"$scanner\", \"input_string\": \"$input_string\"}")
    server_tokens=$(echo "$server_response")

    scanner_path=""
    case "$scanner" in
    "NaiveScanner")
        scanner_path="$naive_scanner_path"
        ;;
    "EMScanner")
        scanner_path="$em_scanner_path"
        ;;
    "SOSScanner")
        scanner_path="$sos_scanner_path"
        ;;
    "NGScanner")
        scanner_path="$ng_scanner_path"
        ;;
    *)
        echo "Invalid scanner specified: $scanner. Valid scanners options are: NaiveScanner, EMScanner, SOSScanner, NGScanner."
        exit 1
        ;;
    esac

    if [ -z "$scanner_path" ]; then
        echo "$scanner not found in any of the directories. Skipping server test."
        exit 1
    fi

    cd "$(dirname "$scanner_path")"

    your_tokens=$(python3 "$(basename "$scanner_path")" -v <(echo -e "$input_string") | head -n -1)

    cd - >/dev/null

    diff_output=$(diff <(echo "$your_tokens") <(echo "$server_tokens"))

    if [ -z "$diff_output" ]; then
        echo -e "\033[0;32mRemote server test passed: $test_name\033[0m"
    else
        echo "$diff_output"
        echo -e "\033[0;31mRemote server test failed: $test_name\033[0m"
    fi

    exit 0
}

if [ -n "$scanner" ] && [ -n "$input_string" ]; then
    servertest
fi

# st end

total_part_1_tests=0
passed_part_1_tests=0
failed_part_1_tests=""

total_part_2_tests=0
passed_part_2_tests=0
failed_part_2_tests=""

total_part_3_tests=0
passed_part_3_tests=0
failed_part_3_tests=""

total_part_4_tests=0
passed_part_4_tests=0
failed_part_4_tests=""

if [ -z "$naive_scanner_path" ]; then
    echo "NaiveScanner.py not found in any of the directories. Skipping part_1_naivescanner tests."
else
    run_test() {
        local test_name="$1"
        local test_command="$2"
        local expected_output="$3"

        echo "Input: $test_command"

        output=$(python3 "$naive_scanner_path" -v <(echo -e "$test_command"))
        time=$(echo "$output" | tail -n 1 | awk '{print $5}')
        output=$(echo "$output" | head -n -1)

        diff_output=$(diff -w --ignore-all-space <(echo -e "$expected_output") <(echo "$output"))

        if [ $? -eq 0 ]; then
            echo -e "\033[0;32mTest passed: $test_name\033[0m"
            ((passed_part_1_tests++))
        else
            echo -e "\033[0;31mTest failed: $test_name\033[0m"
            echo "$diff_output"
            failed_part_1_tests+="$test_name "
        fi

        ((total_part_1_tests++))
        echo "------------------------"
    }

    run_test "part_1_part1" "x = 75 + 99.99 + 44.77 + 65 * 322; = abc * cde + 434 * 0.99;" "(Token.ID,\"x\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"75\")\n(Token.ADD,\"+\")\n(Token.NUM,\"99.99\")\n(Token.ADD,\"+\")\n(Token.NUM,\"44.77\")\n(Token.ADD,\"+\")\n(Token.NUM,\"65\")\n(Token.MULT,\"*\")\n(Token.NUM,\"322\")\n(Token.SEMI,\";\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"abc\")\n(Token.MULT,\"*\")\n(Token.ID,\"cde\")\n(Token.ADD,\"+\")\n(Token.NUM,\"434\")\n(Token.MULT,\"*\")\n(Token.NUM,\"0.99\")\n(Token.SEMI,\";\")"

    run_test "part_1_test10" "qnfvewiaroqrtpsnuzsv     9282673478055564 6481403296931150    6239950836528727 2674251860793069     7419920513384560   ggekvwmxlkhxootdxkph  \n7889730885164327  sypfmmtlvnbmdvvgzord  imvzzieuqggutpehvwac   " "(Token.ID,\"qnfvewiaroqrtpsnuzsv\")\n(Token.NUM,\"9282673478055564\")\n(Token.NUM,\"6481403296931150\")\n(Token.NUM,\"6239950836528727\")\n(Token.NUM,\"2674251860793069\")\n(Token.NUM,\"7419920513384560\")\n(Token.ID,\"ggekvwmxlkhxootdxkph\")\n(Token.NUM,\"7889730885164327\")\n(Token.ID,\"sypfmmtlvnbmdvvgzord\")\n(Token.ID,\"imvzzieuqggutpehvwac\")"

    run_test "part_1_test100" "5246034033840169 pqenuusjtobuaygippgm     eczkdeeipffbbbgvquso    4658519645112717    8813224582856821  qhtntfyitkmbpvczliyd 2433372961572759    9781787139062359   rcsxayholxolokqhekuu 4001578750150371     \n3749116263658236    479675578901776   dctmlcahavbtfnupedff  wkzgyqedgdivkdxlesju  \n3023244802510947    saddksljurhyvmpspenr    mmnyvrquldkavqjxlyfp    2847319346986560 \nbbohdkoxvmfbpbiwlhmx     3703527471249322    6813741029591022     tfutxjkkjytpjiqujmfr   5656589168727043 dlxjteoildthhliieogq   3739551260946348  ypgsnjvcvhccsakmblym 4965168267846670   \nqtlrjusuglmrsfmnceup    \n6376004740314852  ztynvpjudufuwvnhtwhd byseicerneqzunxbkkdc xeeqvhkbfrdtejwgfoad vagzmpigdmdpxnhpnpbh     6697253570476650  1628289123925367   rlxpdzdyvhswtcsdeyoe     6240484803106991     mbpoqoxoxhmtaewvlbor   uajttunbtetzvczjqowm xtyduwdrfwqfibiwgsod     jfusupsjwvyhytewjfmy   \n1281853882390152    3518729720027789    ibcqfjivviwpqnpntpim   mptdmerjcpiozthtiuwz  \nvljpavhpptstrsyqjbgr   vqmmsfkmqrjcovepmuhl  ieacwnxfaohkwbcmknoo    \n5685043539718356     feyokucdcqldpubiyxuk   ymyfiqavlmrunvypsctu  2489847280057870 4859399855303587     rroviwwwdrxpscbfefjy    1424179438666327  3810242026790929     \n6399297424838160    fpzcvfvhmsugzructhbi mwoqipaadsmspmscgdxc  bgzetczsndscwedteotr     gpwsusfvicevzuziblvy    6798984567325311    8084556568814522   6339725911415401     \n5458471396634886   3377025139459741  4316978345579153  5524427385832312   2908112011479650    vmdaylsjyutccgsnckmo    4158164208809632   qjgwomyhkgiogrylkobz advbubdxmnljnyxsjyfq 3137678707749555     uqhvjrabgeeofstemdrs rryndapbysuzlpvwmuxb  \n737726084377106  7718432485351053 3694103590422466    rdmruahixidbplzsxxma    9364901480154999    ymmpjwzfxrbkjntpetap   coddmcaksrlvpgoquteq zagjzueblggbtogdwbry    8482730478355099 6098194975324219   3876940391581868  \ntpzlrwwkievacjezjbvm  rbrvkqipajzrlretxfuc  bqoecxrgwpjvdkvtkpby     7865592970580921     7621293062276835     1005277960186075     fkzhnhlrejkcsrxmwhgz    sihquvfevduourtnwzuz   orokdhxyvaixkgzefbma    4735593784906880  nzsgjrwghzbosovozkbw   wbeujujucffiqlbujjil   aqpgixqvuqjeljfaxhgd \n" "(Token.NUM,\"5246034033840169\")\n(Token.ID,\"pqenuusjtobuaygippgm\")\n(Token.ID,\"eczkdeeipffbbbgvquso\")\n(Token.NUM,\"4658519645112717\")\n(Token.NUM,\"8813224582856821\")\n(Token.ID,\"qhtntfyitkmbpvczliyd\")\n(Token.NUM,\"2433372961572759\")\n(Token.NUM,\"9781787139062359\")\n(Token.ID,\"rcsxayholxolokqhekuu\")\n(Token.NUM,\"4001578750150371\")\n(Token.NUM,\"3749116263658236\")\n(Token.NUM,\"479675578901776\")\n(Token.ID,\"dctmlcahavbtfnupedff\")\n(Token.ID,\"wkzgyqedgdivkdxlesju\")\n(Token.NUM,\"3023244802510947\")\n(Token.ID,\"saddksljurhyvmpspenr\")\n(Token.ID,\"mmnyvrquldkavqjxlyfp\")\n(Token.NUM,\"2847319346986560\")\n(Token.ID,\"bbohdkoxvmfbpbiwlhmx\")\n(Token.NUM,\"3703527471249322\")\n(Token.NUM,\"6813741029591022\")\n(Token.ID,\"tfutxjkkjytpjiqujmfr\")\n(Token.NUM,\"5656589168727043\")\n(Token.ID,\"dlxjteoildthhliieogq\")\n(Token.NUM,\"3739551260946348\")\n(Token.ID,\"ypgsnjvcvhccsakmblym\")\n(Token.NUM,\"4965168267846670\")\n(Token.ID,\"qtlrjusuglmrsfmnceup\")\n(Token.NUM,\"6376004740314852\")\n(Token.ID,\"ztynvpjudufuwvnhtwhd\")\n(Token.ID,\"byseicerneqzunxbkkdc\")\n(Token.ID,\"xeeqvhkbfrdtejwgfoad\")\n(Token.ID,\"vagzmpigdmdpxnhpnpbh\")\n(Token.NUM,\"6697253570476650\")\n(Token.NUM,\"1628289123925367\")\n(Token.ID,\"rlxpdzdyvhswtcsdeyoe\")\n(Token.NUM,\"6240484803106991\")\n(Token.ID,\"mbpoqoxoxhmtaewvlbor\")\n(Token.ID,\"uajttunbtetzvczjqowm\")\n(Token.ID,\"xtyduwdrfwqfibiwgsod\")\n(Token.ID,\"jfusupsjwvyhytewjfmy\")\n(Token.NUM,\"1281853882390152\")\n(Token.NUM,\"3518729720027789\")\n(Token.ID,\"ibcqfjivviwpqnpntpim\")\n(Token.ID,\"mptdmerjcpiozthtiuwz\")\n(Token.ID,\"vljpavhpptstrsyqjbgr\")\n(Token.ID,\"vqmmsfkmqrjcovepmuhl\")\n(Token.ID,\"ieacwnxfaohkwbcmknoo\")\n(Token.NUM,\"5685043539718356\")\n(Token.ID,\"feyokucdcqldpubiyxuk\")\n(Token.ID,\"ymyfiqavlmrunvypsctu\")\n(Token.NUM,\"2489847280057870\")\n(Token.NUM,\"4859399855303587\")\n(Token.ID,\"rroviwwwdrxpscbfefjy\")\n(Token.NUM,\"1424179438666327\")\n(Token.NUM,\"3810242026790929\")\n(Token.NUM,\"6399297424838160\")\n(Token.ID,\"fpzcvfvhmsugzructhbi\")\n(Token.ID,\"mwoqipaadsmspmscgdxc\")\n(Token.ID,\"bgzetczsndscwedteotr\")\n(Token.ID,\"gpwsusfvicevzuziblvy\")\n(Token.NUM,\"6798984567325311\")\n(Token.NUM,\"8084556568814522\")\n(Token.NUM,\"6339725911415401\")\n(Token.NUM,\"5458471396634886\")\n(Token.NUM,\"3377025139459741\")\n(Token.NUM,\"4316978345579153\")\n(Token.NUM,\"5524427385832312\")\n(Token.NUM,\"2908112011479650\")\n(Token.ID,\"vmdaylsjyutccgsnckmo\")\n(Token.NUM,\"4158164208809632\")\n(Token.ID,\"qjgwomyhkgiogrylkobz\")\n(Token.ID,\"advbubdxmnljnyxsjyfq\")\n(Token.NUM,\"3137678707749555\")\n(Token.ID,\"uqhvjrabgeeofstemdrs\")\n(Token.ID,\"rryndapbysuzlpvwmuxb\")\n(Token.NUM,\"737726084377106\")\n(Token.NUM,\"7718432485351053\")\n(Token.NUM,\"3694103590422466\")\n(Token.ID,\"rdmruahixidbplzsxxma\")\n(Token.NUM,\"9364901480154999\")\n(Token.ID,\"ymmpjwzfxrbkjntpetap\")\n(Token.ID,\"coddmcaksrlvpgoquteq\")\n(Token.ID,\"zagjzueblggbtogdwbry\")\n(Token.NUM,\"8482730478355099\")\n(Token.NUM,\"6098194975324219\")\n(Token.NUM,\"3876940391581868\")\n(Token.ID,\"tpzlrwwkievacjezjbvm\")\n(Token.ID,\"rbrvkqipajzrlretxfuc\")\n(Token.ID,\"bqoecxrgwpjvdkvtkpby\")\n(Token.NUM,\"7865592970580921\")\n(Token.NUM,\"7621293062276835\")\n(Token.NUM,\"1005277960186075\")\n(Token.ID,\"fkzhnhlrejkcsrxmwhgz\")\n(Token.ID,\"sihquvfevduourtnwzuz\")\n(Token.ID,\"orokdhxyvaixkgzefbma\")\n(Token.NUM,\"4735593784906880\")\n(Token.ID,\"nzsgjrwghzbosovozkbw\")\n(Token.ID,\"wbeujujucffiqlbujjil\")\n(Token.ID,\"aqpgixqvuqjeljfaxhgd\")"

    run_test "part_1_add" "69420.6969 + 42000.00000 + 666 + 6666699999 + 69420.69420 + 69420.999666000" "(Token.NUM,\"69420.6969\")\n(Token.ADD,\"+\")\n(Token.NUM,\"42000.00000\")\n(Token.ADD,\"+\")\n(Token.NUM,\"666\")\n(Token.ADD,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.ADD,\"+\")\n(Token.NUM,\"69420.69420\")\n(Token.ADD,\"+\")\n(Token.NUM,\"69420.999666000\")"

    run_test "part_1_assign" "69420.6969 * 42000.006969 + 6666699999 * 666 = 69420.999669420 + 999669420.0469020" "(Token.NUM,\"69420.6969\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42000.006969\")\n(Token.ADD,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.MULT,\"*\")\n(Token.NUM,\"666\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69420.999669420\")\n(Token.ADD,\"+\")\n(Token.NUM,\"999669420.0469020\")"

    run_test "part_1_id" "3621.6969 + 3621.0000 + 362169 + 696969 + 1269420.999 + 666.3621" "(Token.NUM,\"3621.6969\")\n(Token.ADD,\"+\")\n(Token.NUM,\"3621.0000\")\n(Token.ADD,\"+\")\n(Token.NUM,\"362169\")\n(Token.ADD,\"+\")\n(Token.NUM,\"696969\")\n(Token.ADD,\"+\")\n(Token.NUM,\"1269420.999\")\n(Token.ADD,\"+\")\n(Token.NUM,\"666.3621\")"

    run_test "part_1_incr" "66666666.0000 ++ 362166666.00000 + 420000000 * 3621 = 69696969.42093621 ; 1337169699.699900999" "(Token.NUM,\"66666666.0000\")\n(Token.INCR,\"++\")\n(Token.NUM,\"362166666.00000\")\n(Token.ADD,\"+\")\n(Token.NUM,\"420000000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69696969.42093621\")\n(Token.SEMI,\";\")\n(Token.NUM,\"1337169699.699900999\")"

    run_test "part_1_mult" "420 * 591337420.00000 + 3621 * 921 * 42069 * 69.420" "(Token.NUM,\"420\")\n(Token.MULT,\"*\")\n(Token.NUM,\"591337420.00000\")\n(Token.ADD,\"+\")\n(Token.NUM,\"3621\")\n(Token.MULT,\"*\")\n(Token.NUM,\"921\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42069\")\n(Token.MULT,\"*\")\n(Token.NUM,\"69.420\")"

    run_test "part_1_num" ".69420 + 3621. * 0.666 * 6969 = 420 * 1337 ; 69.0000000420 ;" "(Token.NUM,\".69420\")\n(Token.ADD,\"+\")\n(Token.NUM,\"3621.\")\n(Token.MULT,\"*\")\n(Token.NUM,\"0.666\")\n(Token.MULT,\"*\")\n(Token.NUM,\"6969\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"420\")\n(Token.MULT,\"*\")\n(Token.NUM,\"1337\")\n(Token.SEMI,\";\")\n(Token.NUM,\"69.0000000420\")\n(Token.SEMI,\";\")"

    run_test "part_1_semi" "69 ; 420.00000 * 3621.0000 * 420 = 69 ; 420 ; 10.0000000002" "(Token.NUM,\"69\")\n(Token.SEMI,\";\")\n(Token.NUM,\"420.00000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621.0000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"420\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69\")\n(Token.SEMI,\";\")\n(Token.NUM,\"420\")\n(Token.SEMI,\";\")\n(Token.NUM,\"10.0000000002\")"

fi

if [ -z "$em_scanner_path" ]; then
    echo "EMScanner.py not found in any of the directories. Skipping part_2_emscanner tests."
else
    run_test() {
        local test_name="$1"
        local test_command="$2"
        local expected_output="$3"

        echo "Input: $test_command"

        output=$(python3 "$em_scanner_path" -v <(echo -e "$test_command"))
        time=$(echo "$output" | tail -n 1 | awk '{print $5}')
        output=$(echo "$output" | head -n -1)

        diff_output=$(diff -w --ignore-all-space <(echo -e "$expected_output") <(echo "$output"))

        if [ $? -eq 0 ]; then
            echo -e "\033[0;32mTest passed: $test_name\033[0m"
            ((passed_part_2_tests++))
        else
            echo -e "\033[0;31mTest failed: $test_name\033[0m"
            echo "$diff_output"
            failed_part_2_tests+="$test_name "
        fi

        ((total_part_2_tests++))
        echo "------------------------"
    }

    run_test "part_2_part2" "try this test case ; = 12345 77.00 0 0xff 0xtesting565 + 99 * 34.00 ( CSE110A + {100.0000 + 9999 )} = {sanity checks CSE110A.001} (this works 00.11 12 0x5678fghj)" "(Token.ID,\"try\")\n(Token.ID,\"this\")\n(Token.ID,\"test\")\n(Token.ID,\"case\")\n(Token.SEMI,\";\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"12345\")\n(Token.NUM,\"77.00\")\n(Token.NUM,\"0\")\n(Token.HNUM,\"0xff\")\n(Token.NUM,\"0\")\n(Token.ID,\"xtesting565\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"99\")\n(Token.MULT,\"*\")\n(Token.NUM,\"34.00\")\n(Token.LPAREN,\"(\")\n(Token.ID,\"CSE110A\")\n(Token.PLUS,\"+\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"100.0000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"9999\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.ID,\"sanity\")\n(Token.ID,\"checks\")\n(Token.ID,\"CSE110A\")\n(Token.NUM,\".001\")\n(Token.RBRACE,\"}\")\n(Token.LPAREN,\"(\")\n(Token.ID,\"this\")\n(Token.ID,\"works\")\n(Token.NUM,\"00.11\")\n(Token.NUM,\"12\")\n(Token.HNUM,\"0x5678f\")\n(Token.ID,\"ghj\")\n(Token.RPAREN,\")\")"

    run_test "part_2_test10" "qnfvewiaroqrtpsnuzsv     9282673478055564 6481403296931150    6239950836528727 2674251860793069     7419920513384560   ggekvwmxlkhxootdxkph  \n7889730885164327  sypfmmtlvnbmdvvgzord  imvzzieuqggutpehvwac   " "(Token.ID,\"qnfvewiaroqrtpsnuzsv\")\n(Token.NUM,\"9282673478055564\")\n(Token.NUM,\"6481403296931150\")\n(Token.NUM,\"6239950836528727\")\n(Token.NUM,\"2674251860793069\")\n(Token.NUM,\"7419920513384560\")\n(Token.ID,\"ggekvwmxlkhxootdxkph\")\n(Token.NUM,\"7889730885164327\")\n(Token.ID,\"sypfmmtlvnbmdvvgzord\")\n(Token.ID,\"imvzzieuqggutpehvwac\")"

    run_test "part_2_test100" "5246034033840169 pqenuusjtobuaygippgm     eczkdeeipffbbbgvquso    4658519645112717    8813224582856821  qhtntfyitkmbpvczliyd 2433372961572759    9781787139062359   rcsxayholxolokqhekuu 4001578750150371     \n3749116263658236    479675578901776   dctmlcahavbtfnupedff  wkzgyqedgdivkdxlesju  \n3023244802510947    saddksljurhyvmpspenr    mmnyvrquldkavqjxlyfp    2847319346986560 \nbbohdkoxvmfbpbiwlhmx     3703527471249322    6813741029591022     tfutxjkkjytpjiqujmfr   5656589168727043 dlxjteoildthhliieogq   3739551260946348  ypgsnjvcvhccsakmblym 4965168267846670   \nqtlrjusuglmrsfmnceup    \n6376004740314852  ztynvpjudufuwvnhtwhd byseicerneqzunxbkkdc xeeqvhkbfrdtejwgfoad vagzmpigdmdpxnhpnpbh     6697253570476650  1628289123925367   rlxpdzdyvhswtcsdeyoe     6240484803106991     mbpoqoxoxhmtaewvlbor   uajttunbtetzvczjqowm xtyduwdrfwqfibiwgsod     jfusupsjwvyhytewjfmy   \n1281853882390152    3518729720027789    ibcqfjivviwpqnpntpim   mptdmerjcpiozthtiuwz  \nvljpavhpptstrsyqjbgr   vqmmsfkmqrjcovepmuhl  ieacwnxfaohkwbcmknoo    \n5685043539718356     feyokucdcqldpubiyxuk   ymyfiqavlmrunvypsctu  2489847280057870 4859399855303587     rroviwwwdrxpscbfefjy    1424179438666327  3810242026790929     \n6399297424838160    fpzcvfvhmsugzructhbi mwoqipaadsmspmscgdxc  bgzetczsndscwedteotr     gpwsusfvicevzuziblvy    6798984567325311    8084556568814522   6339725911415401     \n5458471396634886   3377025139459741  4316978345579153  5524427385832312   2908112011479650    vmdaylsjyutccgsnckmo    4158164208809632   qjgwomyhkgiogrylkobz advbubdxmnljnyxsjyfq 3137678707749555     uqhvjrabgeeofstemdrs rryndapbysuzlpvwmuxb  \n737726084377106  7718432485351053 3694103590422466    rdmruahixidbplzsxxma    9364901480154999    ymmpjwzfxrbkjntpetap   coddmcaksrlvpgoquteq zagjzueblggbtogdwbry    8482730478355099 6098194975324219   3876940391581868  \ntpzlrwwkievacjezjbvm  rbrvkqipajzrlretxfuc  bqoecxrgwpjvdkvtkpby     7865592970580921     7621293062276835     1005277960186075     fkzhnhlrejkcsrxmwhgz    sihquvfevduourtnwzuz   orokdhxyvaixkgzefbma    4735593784906880  nzsgjrwghzbosovozkbw   wbeujujucffiqlbujjil   aqpgixqvuqjeljfaxhgd \n" "(Token.NUM,\"5246034033840169\")\n(Token.ID,\"pqenuusjtobuaygippgm\")\n(Token.ID,\"eczkdeeipffbbbgvquso\")\n(Token.NUM,\"4658519645112717\")\n(Token.NUM,\"8813224582856821\")\n(Token.ID,\"qhtntfyitkmbpvczliyd\")\n(Token.NUM,\"2433372961572759\")\n(Token.NUM,\"9781787139062359\")\n(Token.ID,\"rcsxayholxolokqhekuu\")\n(Token.NUM,\"4001578750150371\")\n(Token.NUM,\"3749116263658236\")\n(Token.NUM,\"479675578901776\")\n(Token.ID,\"dctmlcahavbtfnupedff\")\n(Token.ID,\"wkzgyqedgdivkdxlesju\")\n(Token.NUM,\"3023244802510947\")\n(Token.ID,\"saddksljurhyvmpspenr\")\n(Token.ID,\"mmnyvrquldkavqjxlyfp\")\n(Token.NUM,\"2847319346986560\")\n(Token.ID,\"bbohdkoxvmfbpbiwlhmx\")\n(Token.NUM,\"3703527471249322\")\n(Token.NUM,\"6813741029591022\")\n(Token.ID,\"tfutxjkkjytpjiqujmfr\")\n(Token.NUM,\"5656589168727043\")\n(Token.ID,\"dlxjteoildthhliieogq\")\n(Token.NUM,\"3739551260946348\")\n(Token.ID,\"ypgsnjvcvhccsakmblym\")\n(Token.NUM,\"4965168267846670\")\n(Token.ID,\"qtlrjusuglmrsfmnceup\")\n(Token.NUM,\"6376004740314852\")\n(Token.ID,\"ztynvpjudufuwvnhtwhd\")\n(Token.ID,\"byseicerneqzunxbkkdc\")\n(Token.ID,\"xeeqvhkbfrdtejwgfoad\")\n(Token.ID,\"vagzmpigdmdpxnhpnpbh\")\n(Token.NUM,\"6697253570476650\")\n(Token.NUM,\"1628289123925367\")\n(Token.ID,\"rlxpdzdyvhswtcsdeyoe\")\n(Token.NUM,\"6240484803106991\")\n(Token.ID,\"mbpoqoxoxhmtaewvlbor\")\n(Token.ID,\"uajttunbtetzvczjqowm\")\n(Token.ID,\"xtyduwdrfwqfibiwgsod\")\n(Token.ID,\"jfusupsjwvyhytewjfmy\")\n(Token.NUM,\"1281853882390152\")\n(Token.NUM,\"3518729720027789\")\n(Token.ID,\"ibcqfjivviwpqnpntpim\")\n(Token.ID,\"mptdmerjcpiozthtiuwz\")\n(Token.ID,\"vljpavhpptstrsyqjbgr\")\n(Token.ID,\"vqmmsfkmqrjcovepmuhl\")\n(Token.ID,\"ieacwnxfaohkwbcmknoo\")\n(Token.NUM,\"5685043539718356\")\n(Token.ID,\"feyokucdcqldpubiyxuk\")\n(Token.ID,\"ymyfiqavlmrunvypsctu\")\n(Token.NUM,\"2489847280057870\")\n(Token.NUM,\"4859399855303587\")\n(Token.ID,\"rroviwwwdrxpscbfefjy\")\n(Token.NUM,\"1424179438666327\")\n(Token.NUM,\"3810242026790929\")\n(Token.NUM,\"6399297424838160\")\n(Token.ID,\"fpzcvfvhmsugzructhbi\")\n(Token.ID,\"mwoqipaadsmspmscgdxc\")\n(Token.ID,\"bgzetczsndscwedteotr\")\n(Token.ID,\"gpwsusfvicevzuziblvy\")\n(Token.NUM,\"6798984567325311\")\n(Token.NUM,\"8084556568814522\")\n(Token.NUM,\"6339725911415401\")\n(Token.NUM,\"5458471396634886\")\n(Token.NUM,\"3377025139459741\")\n(Token.NUM,\"4316978345579153\")\n(Token.NUM,\"5524427385832312\")\n(Token.NUM,\"2908112011479650\")\n(Token.ID,\"vmdaylsjyutccgsnckmo\")\n(Token.NUM,\"4158164208809632\")\n(Token.ID,\"qjgwomyhkgiogrylkobz\")\n(Token.ID,\"advbubdxmnljnyxsjyfq\")\n(Token.NUM,\"3137678707749555\")\n(Token.ID,\"uqhvjrabgeeofstemdrs\")\n(Token.ID,\"rryndapbysuzlpvwmuxb\")\n(Token.NUM,\"737726084377106\")\n(Token.NUM,\"7718432485351053\")\n(Token.NUM,\"3694103590422466\")\n(Token.ID,\"rdmruahixidbplzsxxma\")\n(Token.NUM,\"9364901480154999\")\n(Token.ID,\"ymmpjwzfxrbkjntpetap\")\n(Token.ID,\"coddmcaksrlvpgoquteq\")\n(Token.ID,\"zagjzueblggbtogdwbry\")\n(Token.NUM,\"8482730478355099\")\n(Token.NUM,\"6098194975324219\")\n(Token.NUM,\"3876940391581868\")\n(Token.ID,\"tpzlrwwkievacjezjbvm\")\n(Token.ID,\"rbrvkqipajzrlretxfuc\")\n(Token.ID,\"bqoecxrgwpjvdkvtkpby\")\n(Token.NUM,\"7865592970580921\")\n(Token.NUM,\"7621293062276835\")\n(Token.NUM,\"1005277960186075\")\n(Token.ID,\"fkzhnhlrejkcsrxmwhgz\")\n(Token.ID,\"sihquvfevduourtnwzuz\")\n(Token.ID,\"orokdhxyvaixkgzefbma\")\n(Token.NUM,\"4735593784906880\")\n(Token.ID,\"nzsgjrwghzbosovozkbw\")\n(Token.ID,\"wbeujujucffiqlbujjil\")\n(Token.ID,\"aqpgixqvuqjeljfaxhgd\")"

    run_test "part_2_assign" "69420.6969 * 42000.006969 + 6666699999 * 666 = 69420.999669420 + 999669420.0469020" "(Token.NUM,\"69420.6969\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42000.006969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.MULT,\"*\")\n(Token.NUM,\"666\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69420.999669420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"999669420.0469020\")"

    run_test "part_2_brace" "black lives matter = blm = grassroots = {(({0x694200009}) + ({0Xblack694200009}) ++ ({0xblack9999999999power}) ; * 99 * ({6942069}))}" "(Token.ID,\"black\")\n(Token.ID,\"lives\")\n(Token.ID,\"matter\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"blm\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"grassroots\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0x694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.NUM,\"99\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"6942069\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_2_conds" "if gay then furry else human = while alive then = {(({0x694200009}) if ++ while ({0Xblack694200009}) while if + if ({0xblack9999999999power}) while ; * ({xxxtentacion999}))}" "(Token.IF,\"if\")\n(Token.ID,\"gay\")\n(Token.ID,\"then\")\n(Token.ID,\"furry\")\n(Token.ELSE,\"else\")\n(Token.ID,\"human\")\n(Token.ASSIGN,\"=\")\n(Token.WHILE,\"while\")\n(Token.ID,\"alive\")\n(Token.ID,\"then\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0x694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.IF,\"if\")\n(Token.INCR,\"++\")\n(Token.WHILE,\"while\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.IF,\"if\")\n(Token.PLUS,\"+\")\n(Token.IF,\"if\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.ID,\"xxxtentacion999\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_2_hnum" "0xddddd420 ++ 0Xblack694200009 ; 0xblack9999999999power ; * e621" "(Token.HNUM,\"0xddddd420\")\n(Token.INCR,\"++\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.SEMI,\";\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.ID,\"e621\")"

    run_test "part_2_id" "3621.6969 + 3621.0000 + 362169 + 696969 + 1269420.999 + 666.3621" "(Token.NUM,\"3621.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621.0000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"362169\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"696969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"1269420.999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666.3621\")"

    run_test "part_2_mult" "420 * 591337420.00000 + 3621 * 921 * 42069 * 69.420" "(Token.NUM,\"420\")\n(Token.MULT,\"*\")\n(Token.NUM,\"591337420.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621\")\n(Token.MULT,\"*\")\n(Token.NUM,\"921\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42069\")\n(Token.MULT,\"*\")\n(Token.NUM,\"69.420\")"

    run_test "part_2_incr" "66666666.0000 ++ 362166666.00000 + 420000000 * 3621 = 69696969.42093621 ; 1337169699.699900999" "(Token.NUM,\"66666666.0000\")\n(Token.INCR,\"++\")\n(Token.NUM,\"362166666.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420000000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69696969.42093621\")\n(Token.SEMI,\";\")\n(Token.NUM,\"1337169699.699900999\")"

    run_test "part_2_paren" "((0xddddd420) ; (0Xxxx694200009) + (0xgay69696969furry) ; * (3621powerpoint)) ++ (69 + 420) ; ((69420 + 69) + (69420))" "(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.HNUM,\"0xddddd420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xxxx694200009\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"xgay69696969furry\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"3621\")\n(Token.ID,\"powerpoint\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")"

    run_test "part_2_plus" "69 + 420 + 69420.6969 + 42000.00000 + 666 + 6666699999 + 69420.69420 + 69420.999666000" "(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"42000.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.999666000\")"

    run_test "part_2_semi" "3621 ; lol ; 420.00000 * 3621.0000 * 420 = 69 ; gay ; 69.69" "(Token.NUM,\"3621\")\n(Token.SEMI,\";\")\n(Token.ID,\"lol\")\n(Token.SEMI,\";\")\n(Token.NUM,\"420.00000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621.0000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"420\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69\")\n(Token.SEMI,\";\")\n(Token.ID,\"gay\")\n(Token.SEMI,\";\")\n(Token.NUM,\"69.69\")"
fi

if [ -z "$sos_scanner_path" ]; then
    echo "SOSScanner.py not found in any of the directories. Skipping part_3_sosscanner tests."
else
    run_test() {
        local test_name="$1"
        local test_command="$2"
        local expected_output="$3"

        echo "Input: $test_command"

        cd "$(dirname "$sos_scanner_path")"

        output=$(python3 "$sos_scanner_path" -v <(echo -e "$test_command"))
        time=$(echo "$output" | tail -n 1 | awk '{print $5}')
        output=$(echo "$output" | head -n -1)

        cd - >/dev/null

        diff_output=$(diff -w --ignore-all-space <(echo -e "$expected_output") <(echo "$output"))

        if [ $? -eq 0 ]; then
            echo -e "\033[0;32mTest passed: $test_name\033[0m"
            ((passed_part_3_tests++))
        else
            echo -e "\033[0;31mTest failed: $test_name\033[0m"
            echo "$diff_output"
            failed_part_3_tests+="$test_name "
        fi

        ((total_part_3_tests++))
        echo "------------------------"
    }

    run_test "part_3_assign" "69420.6969 * 42000.006969 + 6666699999 * 666 = 69420.999669420 + 999669420.0469020" "(Token.NUM,\"69420.6969\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42000.006969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.MULT,\"*\")\n(Token.NUM,\"666\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69420.999669420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"999669420.0469020\")"

    run_test "part_3_brace" "black lives matter = blm = grassroots = {(({0x694200009}) + ({0Xblack694200009}) ++ ({0xblack9999999999power}) ; * 99 * ({6942069}))}" "(Token.ID,\"black\")\n(Token.ID,\"lives\")\n(Token.ID,\"matter\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"blm\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"grassroots\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0x694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.NUM,\"99\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"6942069\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_3_conds" "if gay then furry else human = while alive then = {(({0x694200009}) if ++ while ({0Xblack694200009}) while if + if ({0xblack9999999999power}) while ; * ({xxxtentacion999}))}" "(Token.IF,\"if\")\n(Token.ID,\"gay\")\n(Token.ID,\"then\")\n(Token.ID,\"furry\")\n(Token.ELSE,\"else\")\n(Token.ID,\"human\")\n(Token.ASSIGN,\"=\")\n(Token.WHILE,\"while\")\n(Token.ID,\"alive\")\n(Token.ID,\"then\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0x694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.IF,\"if\")\n(Token.INCR,\"++\")\n(Token.WHILE,\"while\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.IF,\"if\")\n(Token.PLUS,\"+\")\n(Token.IF,\"if\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.ID,\"xxxtentacion999\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_3_hnum" "0xddddd420 ++ 0Xblack694200009 ; 0xblack9999999999power ; * e621" "(Token.HNUM,\"0xddddd420\")\n(Token.INCR,\"++\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.SEMI,\";\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.ID,\"e621\")"

    run_test "part_3_id" "3621.6969 + 3621.0000 + 362169 + 696969 + 1269420.999 + 666.3621" "(Token.NUM,\"3621.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621.0000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"362169\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"696969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"1269420.999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666.3621\")"

    run_test "part_3_mult" "420 * 591337420.00000 + 3621 * 921 * 42069 * 69.420" "(Token.NUM,\"420\")\n(Token.MULT,\"*\")\n(Token.NUM,\"591337420.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621\")\n(Token.MULT,\"*\")\n(Token.NUM,\"921\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42069\")\n(Token.MULT,\"*\")\n(Token.NUM,\"69.420\")"

    run_test "part_3_incr" "66666666.0000 ++ 362166666.00000 + 420000000 * 3621 = 69696969.42093621 ; 1337169699.699900999" "(Token.NUM,\"66666666.0000\")\n(Token.INCR,\"++\")\n(Token.NUM,\"362166666.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420000000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69696969.42093621\")\n(Token.SEMI,\";\")\n(Token.NUM,\"1337169699.699900999\")"

    run_test "part_3_paren" "((0xddddd420) ; (0Xxxx694200009) + (0xgay69696969furry) ; * (3621powerpoint)) ++ (69 + 420) ; ((69420 + 69) + (69420))" "(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.HNUM,\"0xddddd420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xxxx694200009\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"xgay69696969furry\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"3621\")\n(Token.ID,\"powerpoint\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")"

    run_test "part_3_plus" "69 + 420 + 69420.6969 + 42000.00000 + 666 + 6666699999 + 69420.69420 + 69420.999666000" "(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"42000.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.999666000\")"

    run_test "part_3_semi" "3621 ; lol ; 420.00000 * 3621.0000 * 420 = 69 ; gay ; 69.69" "(Token.NUM,\"3621\")\n(Token.SEMI,\";\")\n(Token.ID,\"lol\")\n(Token.SEMI,\";\")\n(Token.NUM,\"420.00000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621.0000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"420\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69\")\n(Token.SEMI,\";\")\n(Token.ID,\"gay\")\n(Token.SEMI,\";\")\n(Token.NUM,\"69.69\")"

fi

if [ -z "$ng_scanner_path" ]; then
    echo "NGScanner.py not found in any of the directories. Skipping part_4_ngscanner tests."
else
    run_test() {
        local test_name="$1"
        local test_command="$2"
        local expected_output="$3"

        echo "Input: $test_command"

        cd "$(dirname "$ng_scanner_path")"

        output=$(python3 "$ng_scanner_path" -v <(echo -e "$test_command"))
        time=$(echo "$output" | tail -n 1 | awk '{print $5}')
        output=$(echo "$output" | head -n -1)

        cd - >/dev/null

        diff_output=$(diff -w --ignore-all-space <(echo -e "$expected_output") <(echo "$output"))

        if [ $? -eq 0 ]; then
            echo -e "\033[0;32mTest passed: $test_name\033[0m"
            ((passed_part_4_tests++))
        else
            echo -e "\033[0;31mTest failed: $test_name\033[0m"
            echo "$diff_output"
            failed_part_4_tests+="$test_name "
        fi

        ((total_part_4_tests++))
        echo "------------------------"
    }

    run_test "part_4_assign" "69420.6969 * 42000.006969 + 6666699999 * 666 = 69420.999669420 + 999669420.0469020" "(Token.NUM,\"69420.6969\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42000.006969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.MULT,\"*\")\n(Token.NUM,\"666\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69420.999669420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"999669420.0469020\")"

    run_test "part_4_brace" "black lives matter = blm = grassroots = {(({0x694200009}) + ({0Xblack694200009}) ++ ({0xblack9999999999power}) ; * 99 * ({6942069}))}" "(Token.ID,\"black\")\n(Token.ID,\"lives\")\n(Token.ID,\"matter\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"blm\")\n(Token.ASSIGN,\"=\")\n(Token.ID,\"grassroots\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0x694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.NUM,\"99\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"6942069\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_4_conds" "if no good cop then bad cop else human = while then = {(if not good cop exist + exists ++ while ({0Xblack694200009}) while if + if ({0xblack9999999999livesmatter}) while ; * ({x40}))}" "(Token.IF,\"if\")\n(Token.ID,\"no\")\n(Token.ID,\"good\")\n(Token.ID,\"cop\")\n(Token.ID,\"then\")\n(Token.ID,\"bad\")\n(Token.ID,\"cop\")\n(Token.ELSE,\"else\")\n(Token.ID,\"human\")\n(Token.ASSIGN,\"=\")\n(Token.WHILE,\"while\")\n(Token.ID,\"then\")\n(Token.ASSIGN,\"=\")\n(Token.LBRACE,\"{\")\n(Token.LPAREN,\"(\")\n(Token.IF,\"if\")\n(Token.ID,\"not\")\n(Token.ID,\"good\")\n(Token.ID,\"cop\")\n(Token.ID,\"exist\")\n(Token.PLUS,\"+\")\n(Token.ID,\"exists\")\n(Token.INCR,\"++\")\n(Token.WHILE,\"while\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.IF,\"if\")\n(Token.PLUS,\"+\")\n(Token.IF,\"if\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999livesmatter\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.WHILE,\"while\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.LBRACE,\"{\")\n(Token.ID,\"x40\")\n(Token.RBRACE,\"}\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.RBRACE,\"}\")"

    run_test "part_4_hnum" "0xddddd420 ++ 0Xblack694200009 ; 0xblack9999999999power ; * e621" "(Token.HNUM,\"0xddddd420\")\n(Token.INCR,\"++\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xblack694200009\")\n(Token.SEMI,\";\")\n(Token.HNUM,\"0xb\")\n(Token.ID,\"lack9999999999power\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.ID,\"e621\")"

    run_test "part_4_id" "3621.6969 + 3621.0000 + 362169 + 696969 + 1269420.999 + 666.3621" "(Token.NUM,\"3621.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621.0000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"362169\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"696969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"1269420.999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666.3621\")"

    run_test "part_4_mult" "420 * 591337420.00000 + 3621 * 921 * 42069 * 69.420" "(Token.NUM,\"420\")\n(Token.MULT,\"*\")\n(Token.NUM,\"591337420.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"3621\")\n(Token.MULT,\"*\")\n(Token.NUM,\"921\")\n(Token.MULT,\"*\")\n(Token.NUM,\"42069\")\n(Token.MULT,\"*\")\n(Token.NUM,\"69.420\")"

    run_test "part_4_incr" "66666666.0000 ++ 362166666.00000 + 420000000 * 3621 = 69696969.42093621 ; 1337169699.699900999" "(Token.NUM,\"66666666.0000\")\n(Token.INCR,\"++\")\n(Token.NUM,\"362166666.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420000000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69696969.42093621\")\n(Token.SEMI,\";\")\n(Token.NUM,\"1337169699.699900999\")"

    run_test "part_4_paren" "((0xddddd420) ; (0Xxxx694200009) + (0xgay69696969furry) ; * (3621powerpoint)) ++ (69 + 420) ; ((69420 + 69) + (69420))" "(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.HNUM,\"0xddddd420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"Xxxx694200009\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"0\")\n(Token.ID,\"xgay69696969furry\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.MULT,\"*\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"3621\")\n(Token.ID,\"powerpoint\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")\n(Token.INCR,\"++\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.RPAREN,\")\")\n(Token.SEMI,\";\")\n(Token.LPAREN,\"(\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69\")\n(Token.RPAREN,\")\")\n(Token.PLUS,\"+\")\n(Token.LPAREN,\"(\")\n(Token.NUM,\"69420\")\n(Token.RPAREN,\")\")\n(Token.RPAREN,\")\")"

    run_test "part_4_plus" "69 + 420 + 69420.6969 + 42000.00000 + 666 + 6666699999 + 69420.69420 + 69420.999666000" "(Token.NUM,\"69\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.6969\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"42000.00000\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"666\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"6666699999\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.69420\")\n(Token.PLUS,\"+\")\n(Token.NUM,\"69420.999666000\")"

    run_test "part_4_semi" "3621 ; lol ; 420.00000 * 3621.0000 * 420 = 69 ; ur gay ; 69.69" "(Token.NUM,\"3621\")\n(Token.SEMI,\";\")\n(Token.ID,\"lol\")\n(Token.SEMI,\";\")\n(Token.NUM,\"420.00000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"3621.0000\")\n(Token.MULT,\"*\")\n(Token.NUM,\"420\")\n(Token.ASSIGN,\"=\")\n(Token.NUM,\"69\")\n(Token.SEMI,\";\")\n(Token.ID,\"ur\")\n(Token.ID,\"gay\")\n(Token.SEMI,\";\")\n(Token.NUM,\"69.69\")"

fi

echo "------------------------"
echo "Local results"
echo "------------------------"

if [ $total_part_1_tests -gt 0 ]; then
    echo "part_1_naivescanner"
    if [ -z "$failed_part_1_tests" ]; then
        echo -e "\033[0;32mAll $total_part_1_tests tests passed!\033[0m"
    else
        echo -e "\033[0;31mFailed test(s): ${failed_part_1_tests}\033[0m"
        echo "Passed $passed_part_1_tests/$total_part_1_tests tests"
    fi
    echo "------------------------"
else
    echo "part_1_naivescanner: Skipped"
    echo "------------------------"
fi

if [ $total_part_2_tests -gt 0 ]; then
    echo "part_2_emscanner"
    if [ -z "$failed_part_2_tests" ]; then
        echo -e "\033[0;32mAll $total_part_2_tests tests passed!\033[0m"
    else
        echo -e "\033[0;31mFailed test(s): ${failed_part_2_tests}\033[0m"
        echo "Passed $passed_part_2_tests/$total_part_2_tests tests"
    fi
    echo "------------------------"
else
    echo "part_2_emscanner: Skipped"
    echo "------------------------"
fi

if [ $total_part_3_tests -gt 0 ]; then
    echo "part_3_sosscanner"
    if [ -z "$failed_part_3_tests" ]; then
        echo -e "\033[0;32mAll $total_part_3_tests tests passed!\033[0m"
    else
        echo -e "\033[0;31mFailed test(s): ${failed_part_3_tests}\033[0m"
        echo "Passed $passed_part_3_tests/$total_part_3_tests tests"
    fi
    echo "------------------------"
else
    echo "part_3_sosscanner: Skipped"
    echo "------------------------"
fi

if [ $total_part_4_tests -gt 0 ]; then
    echo "part_4_ngscanner"
    if [ -z "$failed_part_4_tests" ]; then
        echo -e "\033[0;32mAll $total_part_4_tests tests passed!\033[0m"
    else
        echo -e "\033[0;31mFailed test(s): ${failed_part_4_tests}\033[0m"
        echo "Passed $passed_part_4_tests/$total_part_4_tests tests"
    fi
    echo "------------------------"
else
    echo "part_4_ngscanner: Skipped"
    echo "------------------------"
fi
echo "------------------------"
echo "This student made test script may contain errors and does not guarantee correctness."
echo "Additionally, you may run with -s and -i, scanner and input parameters, respectively, to test against remote."
echo "For example: ./hw1testscript.sh -s \"SOSScanner\" -i \"1 + 1 ; acab *\""
echo "------------------------"
