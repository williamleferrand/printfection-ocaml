open Misc
open Types

let base_request connection = 
  [
    "api_key", connection.key; 
    "version", "1.0"; 
    "response_format", "XML"; 
    "session_key", connection.session_key 
  ]

let rec search label = function 
    Xml.Element (l, _, children) when l = label -> Some children
  | Xml.PCData (_) -> None 
  | Xml.Element (l, _, children) -> 
      List.fold_left (fun acc child -> 
			match acc with
			    Some _ -> acc 
			  | None -> search label child) None children  ;;
			  
module Auth_createToken = 
  struct 
    let raw_exec connection = 

      let request = 
	("method", "Printfection.Auth.createToken") 
	:: (base_request connection) in

      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  

    let exec connection = 

      let result = raw_exec connection in
	debug "@@@ Result: %s\n" result; 
 
      let xml = Xml.parse_string result in
     
	match search "auth_token" xml with 
	    Some (Xml.PCData token  :: _) -> token 
	  | _ -> raise Malformed       
  end
    
module Misc_getUrl = 
  struct 
    let raw_exec connection permissions = 
            
      let request = 
	("permissions", permissions) 
	  :: (base_request connection) in
	
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send_auth connection  
  end
  

module Auth_getSession = 
  struct 
    let raw_exec connection token = 
      debug "@@@ getSession for token %s\n" token ;
      let request = 
	("method", "Printfection.Auth.getSession")
	:: ("auth_token", token)
	:: (base_request connection) in

      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  
	  
    let exec connection token = 
       let result = raw_exec connection token in
	debug "@@@ Result: %s\n" result; 

      let xml = Xml.parse_string result in
     
	match search "session_key" xml with 
	    Some (Xml.PCData session_key  :: _) -> session_key
	  | _ -> raise Malformed     
  end

module Cart_create = 
  struct 
    let raw_exec connection = 
      let request = 
	("method", "printfection.carts.create") 
	:: (base_request connection) in
	
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  

    let exec connection = 
      let result = raw_exec connection in
      let xml = Xml.parse_string result in
	
	match search "cart_key" xml with 
	    Some (Xml.PCData cart_key  :: _) -> cart_key
	  | _ -> raise Malformed   
      
  end

module PSQL_query = 
  struct 
    let raw_exec connection query =
        let request = 
	  ("method", "Printfection.PFQL.query") 
	  :: ("query", query)
	  :: (base_request connection) in
	  
	let signature = Authentication.sign connection request in
	  ("api_sig", signature) :: request >>> Effector.send connection  
      
  end


module Product_create = 
  struct 
    let raw_exec connection rootid sectionid colors specs = 
      let request = 
	("method", "Printfection.Products.create") 
	:: ("rootid", rootid ) 
	:: ("sectionid", sectionid)
	:: ("rootcolorids", colors)
	:: ("specs", specs) 
	:: (base_request connection) in
		  
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  

    let exec connection rootid sectionid colors specs = 
      let result = raw_exec connection rootid sectionid colors specs in
      print_endline result ; flush stdout ; 
      let xml = Xml.parse_string result in
	
	match search "productid" xml with 
	    Some (Xml.PCData e  :: _) -> e
	  | _ -> raise Malformed   
  end



module Product_set = 
  struct 
    let raw_exec connection productid title commission = 
      let request = 
	("method", "Printfection.Products.set") 
	:: ("productid", productid ) 
	:: ("title", title) 
	:: ("commission", commission)
	:: (base_request connection) in
		  
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  

  end

module Cart_addProduct = 
struct 
  let raw_exec connection cart_key productid rootcolorid rootsizeid qty = 
     let request = 
       ("method", "Printfection.Carts.addProduct") 
       :: ("cart_key", cart_key ) 
       :: ("productid", productid)
       :: ("rootcolorid", rootcolorid)
       :: ("rootsizeid", rootsizeid) 
       :: ("qty", qty) 
       :: (base_request connection) in
       
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send connection  
end




module Checkout = 
struct 
  let raw_exec connection cart_key storeid landing_page  = 
        
      let request = 
	("cart_key", cart_key)
	:: ("storeid", storeid) 
	:: ("landing_page", landing_page)
	:: (base_request connection) in
	
      let signature = Authentication.sign connection request in
	("api_sig", signature) :: request >>> Effector.send_checkout connection  
  end 

module Upload = 
  struct 
    let raw_exec connection name imagesetid file = 
       let request = 
	 ("method", "Printfection.Images.upload")
	:: ("name", name)
	:: ("imagesetid", imagesetid) 
	:: (base_request connection) in
	 
       let signature = Authentication.sign connection request in
	 ("api_sig", signature) :: request >>> Effector.send_upload file

    let exec connection name imagesetid file = 
         let result = raw_exec connection name imagesetid file in
	 let xml = Xml.parse_string result in

	match search "imageid" xml with 
	    Some (Xml.PCData e  :: _) -> e
	  | _ -> raise Malformed   
  end
