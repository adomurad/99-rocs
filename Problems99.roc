interface Problems99
    exposes []
    imports []
    

## -----------------------------------------------------------------
## Problem 1
## Find the last element of a list

myLast = List.last


# expect to get last element
expect
    actual = myLast [1, 2, 3, 4, 5]
    expected = Ok 5

    actual == expected


# expect to get error when list is empty
expect
    actual = myLast []
    expected = Err ListWasEmpty

    actual == expected


## -----------------------------------------------------------------
## Problem 2
## Find the last-but-one (or second-last) element of a list

secondLast = \list ->
    len = List.len list 
    if len < 2 then
        Err OutOfBounds
    else
        list 
        |> List.get (len - 2) 


# expect to get second-last element
expect
    actual = secondLast [1, 2, 3, 4, 5]
    expected = Ok 4

    actual == expected


# expect to get error when list is empty
expect
    actual = secondLast []
    expected = Err OutOfBounds

    actual == expected

# expect to get error when list has only 1 element
expect
    actual = secondLast [1]
    expected = Err OutOfBounds

    actual == expected


## -----------------------------------------------------------------
## Problem 3
## Find the K'th element of a list
## * first element in the list is number 1

elementAt = \list, at ->
    list |>List.get (at - 1)


# expect to get nth element
expect
    actual = elementAt [1, 2, 3, 4, 5] 2
    expected = Ok 2

    actual == expected


# expect to get OutOfBounds error
expect
    actual = elementAt [1, 2, 3, 4, 5] 6
    expected = Err OutOfBounds

    actual == expected


## -----------------------------------------------------------------
## Problem 4
## Find the number of elements in a list

length = List.len


# expect to length of a list
expect
    actual = length [1, 2, 3, 4, 5]
    expected = 5

    actual == expected


# expect to length of an empty list
expect
    actual = length []
    expected = 0

    actual == expected


## -----------------------------------------------------------------
## Problem 5
## Reverse a list

reverse = List.reverse


# expect to reverse a list
expect
    actual = reverse [1, 2, 3, 4, 5]
    expected = [5, 4, 3, 2, 1]

    actual == expected


# expect to reverse an empty list
expect
    actual = reverse []
    expected = []

    actual == expected


## -----------------------------------------------------------------
## Problem 6
## Find out wheter a list is a palindrome

isPalindrome : List a -> Bool | a has Eq
isPalindrome = \list ->
    list == List.reverse list


# expect to return true for a palindrome
expect
    actual = isPalindrome [1, 2, 3, 2, 1]
    expected = Bool.true

    actual == expected


# expect to return false for a non-palindrome
expect
    actual = isPalindrome [1, 2, 3, 2, 2]
    expected = Bool.false

    actual == expected

# expect to return false for an empty list
expect
    actual = isPalindrome []
    expected = Bool.true

    actual == expected



isPalindromeStr : Str -> Bool
isPalindromeStr = \str ->
    reversedStr =
        str
        |> Str.graphemes
        |> List.reverse
        |> Str.joinWith ""

    str == reversedStr


# expect to return true for a palindrome
expect
    actual = isPalindromeStr "kajak"
    expected = Bool.true

    actual == expected


# expect to return false for a non-palindrome
expect
    actual = isPalindromeStr "kajaj"
    expected = Bool.false

    actual == expected

# expect to return false for an empty list
expect
    actual = isPalindromeStr ""
    expected = Bool.true

    actual == expected


## -----------------------------------------------------------------
## Problem 7
## Flatten a nested list structure

NestedList a : [
    Elem a,
    NestedList (List (NestedList a)),
]

flatten : NestedList a -> List a
flatten = \nestedList ->
    when nestedList is
        Elem a -> [a]
        NestedList list -> 
            list |> List.walk [] \state, elem ->
                List.concat state (flatten elem)


# expect to flatten a single element
expect
    actual = flatten (Elem 5)
    expected = [5]

    actual == expected


# expect to return a flat list
expect
    actual = flatten (NestedList [Elem 1, Elem 2, Elem 3])
    expected = [1, 2, 3]

    actual == expected

# expect to flatten a nested list
expect
    actual = flatten (NestedList [Elem 1, NestedList [Elem 2, NestedList [Elem 3], Elem 4], Elem 5])
    expected = [1, 2, 3, 4, 5]

    actual == expected

# expect to flatten an empty list
expect
    actual = flatten (NestedList [])
    expected = []

    actual == expected


## -----------------------------------------------------------------
## Problem 8
## Eliminate consecutive duplicates of list elements

compress = \list ->
    list |> List.walk [] \state, elem -> 
        when List.last state is
            Ok a if a == elem -> state 
            _ -> List.append state elem


# expect to remove consecutive duplicates
expect
    actual = compress [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]
    expected = [1, 2, 3, 4, 5]

    actual == expected



## -----------------------------------------------------------------
## Problem 9
## Pack consecutive duplicates of list elements into sublists

pack = \list ->
    list |> List.walk [] \state, elem -> 
        when List.last state is
            Err ListWasEmpty -> [elem]
            Ok lastStr ->
                if lastStr |> Str.endsWith elem then 
                    len = state |> List.len
                    state |> List.update (len - 1) \x -> "\(x)\(elem)"
                else
                    List.append state elem


# expect to pack cosecutive duplicates
expect
    actual = pack ["a", "a", "a", "b", "c", "c", "c", "c", "c"]
    expected = ["aaa", "b", "ccccc"]

    actual == expected




## -----------------------------------------------------------------
## Problem 10
## Run-length encoding of a list

encode = \list ->
    list |> List.walk [] \state, elem -> 
        when List.last state is
            Err ListWasEmpty -> [(1, elem)]
            Ok (n, e) ->
                if e == elem then 
                    len = state |> List.len
                    state |> List.update (len - 1) \(k, el) -> (k + 1, el)
                else
                    List.append state (1, elem)


# expect to pack cosecutive duplicates
expect
    actual = encode ["a", "a", "a", "b", "c", "c", "c", "c", "c"]
    expected = [(3, "a"), (1, "b"), (5, "c")]

    actual == expected
