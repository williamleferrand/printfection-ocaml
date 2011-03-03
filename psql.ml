open Misc

(* myTwittshirt credentials *)
let api_key = "5b7c84da92990dda790c0c9efb06717d"
let secret_key = "7130f8c6683d2e860cc59ec78e282b63"
let session_key = "30921627631c4380-104719" 


let api_key = "22509e9232e615fe6db04afe55be8974" 
let secret_key = "54b4f88095cf9a55752808ea385a035e"
let auth_token = "850dabde4c4a803f4b408d06e3ec9d08"
let session_key = "9c14b2d30df47f98-104719" 

let _ = 
  debug "@@@ PSQL command line tool\n" ;
  let connection = Connection.create api_key secret_key session_key in

  while true do
    print_string "> " ; flush stdout ; 
    let query = input_line stdin in
    let response = Command.PSQL_query.raw_exec connection query in
    let xml = Xml.parse_string response in
      
      print_string (Xml.to_string_fmt xml) ; print_newline () ; flush stdout 

  done
