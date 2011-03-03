open Misc  
open Types
 
let sign connection request = 
  let sorted_attributes = List.sort (fun (k1, v1)  (k2, v2) -> String.compare k1 k2) request in

  let raw_request = List.fold_left (fun acc (k,v) -> 
				      Printf.sprintf "%s%s=%s" acc k v) "" sorted_attributes in
    
    let hasher = Cryptokit.Hash.md5 () in
    let encoder = Cryptokit.Hexa.encode () in
    let req = raw_request ^ connection.secret in
      Cryptokit.hash_string hasher req >>> Cryptokit.transform_string encoder >>> String.lowercase 
      
        
      
	    
  
 

