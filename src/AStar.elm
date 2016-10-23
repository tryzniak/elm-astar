module AStar exposing (aStar)

import Array exposing (Array(..))
import Maybe exposing (Maybe(..))
import Set exposing (Set(..))
import PairingHeap as PH


-- Returns a shortest path from a source node to a goal node.
-- If a path does not exist Nothing is returned.
-- TODO: Describe the arguments
-- getNeighbors:
-- heuristic: A function which takes a point and returns a value used to
-- prioritize exploration. Often this is either the manhattan or euclidean
-- distance to a goal. This must satisfy the triangle inequality.
-- sources: A list of inital points to start from
-- goals: A set of goals
--aStar :
--    (comparable -> List ( comparable, number ))
--    -> (comparable -> number)
--    -> List comparable
--    -> Set comparable
--    -> Maybe (List comparable)


aStar getNeighbors heuristic sources goals =
    Maybe.map Array.toList (aStarArray getNeighbors heuristic sources goals)



-- NOTE: Uncommenting this will give a type error about not matching the
-- inferred type despite the inferred type being exactly this.
-- NOTE2: If you uncomment the type annotation for aStar' the inferred type
-- annotation here changes.
--aStarArray :
--    (comparable -> List ( comparable, number ))
--    -> (comparable -> number)
--    -> List comparable
--    -> Set comparable
--    -> Maybe (Array comparable)


aStarArray getNeighbors heuristic sources goals =
    let
        aStar' :
            PH.PairingHeap number ( number, comparable, Array comparable )
            -> Set comparable
            -> Maybe (Array comparable)
        aStar' open closed =
            case (PH.findMin open) of
                Nothing ->
                    Nothing

                Just ( cost, ( dist, nextNode, partPath ) ) ->
                    if Set.member nextNode goals then
                        Just partPath
                    else
                        let
                            closed' : Set comparable
                            closed' =
                                Set.insert nextNode closed

                            neighbors : List comparable
                            neighbors =
                                List.filter (\x -> not (Set.member x closed')) (getNeighbors nextNode)

                            open' : PH.PairingHeap number ( number, comparable, Array comparable )
                            open' =
                                List.foldl
                                    (\( x, d ) ->
                                        PH.insert ( dist + d + heuristic x, ( dist + d, x, Array.push x partPath ) )
                                    )
                                    (PH.deleteMin open)
                                    neighbors
                        in
                            aStar' open' closed'
    in
        aStar' (PH.fromList (List.map (\x -> ( heuristic x, ( 0, x, Array.repeat 1 x ) )) sources)) Set.empty
