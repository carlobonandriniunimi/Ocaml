type priority = int
type 'a queue = Empty | Node of priority * 'a * 'a queue * 'a queue

let empty = Empty

let rec insert queue prio elt =
  match queue with
  | Empty -> Node (prio, elt, Empty, Empty)
  | Node (p, e, left, right) ->
      if prio <= p then Node (prio, elt, insert right p e, left)
      else Node (p, e, insert right prio elt, left)

exception Empty_queue

let rec remove_top = function
  | Empty -> raise Empty_queue
  | Node (prio, elt, left, Empty) -> left
  | Node (prio, elt, Empty, right) -> right
  | Node
      ( prio,
        elt,
        (Node (lprio, lelt, _, _) as left),
        (Node (rprio, relt, _, _) as right) ) ->
      if lprio <= rprio then Node (lprio, lelt, remove_top left, right)
      else Node (rprio, relt, left, remove_top right)

let extract = function
  | Empty -> raise Empty_queue
  | Node (prio, elt, _, _) as queue -> (prio, elt, remove_top queue)
