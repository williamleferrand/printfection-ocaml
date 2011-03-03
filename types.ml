type connection = 
    { 
      http_host_base : string ; 
      http_host_upload : string ; 

      http_uri_base : string ; 
      http_uri_upload : string ; 
      
      key : string ;
      secret : string ; 

      session_key : string ; 
    }

exception Error of string 

exception Malformed 
