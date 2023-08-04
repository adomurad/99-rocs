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