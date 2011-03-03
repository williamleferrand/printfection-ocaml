open Misc
open Types

let send connection request = 
  let encoded_request = List.map (fun (k, v) -> encode k, encode v) request in
  let formatted_request = List.fold_left (fun acc (k,v) -> if acc = "" then Printf.sprintf "%s=%s" k v else Printf.sprintf "%s&%s=%s" acc k v) "" encoded_request in
  
    Printf.sprintf "http://%s%s?%s" connection.http_host_base connection.http_uri_base formatted_request >>>  Http_client.Convenience.http_get 
   

let send_upload file request =
  
  let writer accum data =
    Buffer.add_string accum data;
    String.length data in
    
  let post_parameters = List.map (fun (k,v) -> Curl.CURLFORM_CONTENT (k, v, Curl.DEFAULT)) request in
  let post_parameters = 
    Curl.CURLFORM_FILE ((Filename.basename file), file, (Curl.CONTENTTYPE "image/png")) :: post_parameters in

  let connection = Curl.init () in
   Curl.setopt connection (Curl.CURLOPT_URL "http://upload.printfection.com/api_upload.php");
   Curl.setopt connection (Curl.CURLOPT_HTTPPOST post_parameters) ; 
   let result = Buffer.create 16384 in
   Curl.set_writefunction connection (writer result);
   Curl.perform connection; 
   Curl.cleanup connection; 
   Buffer.contents result 





let send_auth connection request = 
  let encoded_request = List.map (fun (k, v) -> encode k, encode v) request in
  let formatted_request = List.fold_left (fun acc (k,v) -> if acc = "" then Printf.sprintf "%s=%s" k v else Printf.sprintf "%s&%s=%s" acc k v) "" encoded_request in
  
  let http_host_base = "www.printfection.com" in
  let http_uri_base = "/app/authorize.php" in
    Printf.sprintf "http://%s%s?%s" http_host_base http_uri_base formatted_request 



let send_checkout connection request = 
  let encoded_request = List.map (fun (k, v) -> encode k, encode v) request in
  let formatted_request = List.fold_left (fun acc (k,v) -> if acc = "" then Printf.sprintf "%s=%s" k v else Printf.sprintf "%s&%s=%s" acc k v) "" encoded_request in
  
  let http_host_base = "www.printfection.com" in
  let http_uri_base = "/app/checkout.php" in
    Printf.sprintf "http://%s%s?%s" http_host_base http_uri_base formatted_request 

