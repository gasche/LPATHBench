open List
open Unix
open Printf
       
type route = {dest: int; cost: int}

type node = route list

type node2 = route array
		  
let readPlaces () =
  let f = open_in "agraph" in
  let next_int () = Scanf.fscanf f " %d" (fun n -> n) in
  let n = next_int () in
  let nodes = Array.init n (fun a -> []) in
  begin
    try while true do
      let node = next_int () in
      let neighbour = next_int () in
      let cost = next_int () in
      nodes.(node) <- ({dest= neighbour; cost=cost} :: nodes.(node));
    done with _ -> ()
  end;
  (nodes, n)
      
let rec getLongestPath nodes nodeID visited =
  visited.(nodeID) <- true;
  let last_neighbor = Array.length nodes.(nodeID) - 1 in
  let max = visit_neighbors nodes nodeID visited last_neighbor 0 in
  visited.(nodeID) <- false;
  max
and visit_neighbors nodes nodeID visited i maxDist =
  if i < 0 then maxDist
  else
    let neighbour = nodes.(nodeID).(i) in
    if visited.(neighbour.dest)
    then visit_neighbors nodes nodeID visited (i-1) maxDist
    else
      let dist =
        neighbour.cost
        + getLongestPath nodes neighbour.dest visited in
      let newMax = if dist > maxDist then dist else maxDist in
      visit_neighbors nodes nodeID visited (i-1) newMax

let () =
  let (nodes, numNodes) = readPlaces() in
  let visited = Array.init numNodes (fun x -> false) in
  let fstNodes = Array.map (fun n1 -> Array.of_list n1) nodes in
  let start = Unix.gettimeofday() in
  let len = getLongestPath fstNodes 0 visited in
  printf "%d LANGUAGE Ocaml %d\n" len (int_of_float @@ 1000. *. (Unix.gettimeofday() -. start))
  (*  print_int @@ getLongestPath nodes 0 visited;*)
