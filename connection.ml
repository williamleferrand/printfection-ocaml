open Types

let create key secret session_key = 
  {
    http_host_base = "api.printfection.com" ;
    http_host_upload = "upload.printfection.com" ;
    
    http_uri_base = "/restserver.php" ; 
    http_uri_upload = "/api_upload.php" ;

    key = key; 
    secret = secret;

    session_key = session_key ; 
  }

