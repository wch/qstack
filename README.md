Fast basic data structures for R
================================

This package contains some experiments in implementing various data structures for R, in some cases with C code and in some cases with plain R. So far only stacks and queues are implemented.

## Stacks

### Pairlist-backed `Stack`

A `Stack` implements a stack using a pairlist (which is a linked list). It is wrapped in an environment (in an OOP style) which provides some methods for working with the stack. Any type of R object can be pushed onto the stack.

```R
library(qstack)

# Create a stack
s <- Stack()

s$push(5)
s$push(10)
s$size()
# [1] 2

s$pop()
# [1] 10
s$pop()
# [1] 5
s$pop()
# NULL

s$push(15)
s$peek()
# [1] 15
s$pop()
# [1] 15
```

In general it is dangerous to manipulate a pairlist the way that is done by the C code underlying `Stack`. This is because it modifies a pairlist directly, but R code generally assumes that pairlists will copied on modification. The `Stack` wrapper protects the user from ever accessing the pairlist directly, so the user doesn't have to worry about this danger.


### List-backed `Stack2`

A `Stack2` has the same interface as a `Stack`, but it is implemented in pure R code. The underlying data structure is a list which is doubled (and copied) as the stack changes in size.

```R
s <- Stack2()

s$push(5)
s$push(10)
s$size()
# [1] 2

s$pop()
# [1] 10
s$pop()
# [1] 5
s$pop()
# NULL

s$push(15)
s$peek()
# [1] 15
s$pop()
# [1] 15
```

### Comparing perfomance of `Stack` and `Stack2`

I've found that pairlist-backed `Stack` and the list-backed `Stack2` have roughly similar performance for adding items, but the `Stack2` is somewhat slower for removing items. For example:

```R
n <- 1e6

system.time({
  s <- Stack()
  for (i in 1:n) s$push(i)
})
#    user  system elapsed 
#   4.566   0.042   4.629 
system.time({
  for (i in 1:n) s$pop()
})
#    user  system elapsed 
#   1.940   0.021   1.971 


system.time({
  s <- Stack2()
  for (i in 1:n) s$push(i)
})
#    user  system elapsed 
#   5.112   0.060   5.204 
system.time({
  for (i in 1:n) s$pop()
})
#    user  system elapsed 
#   4.154   0.050   4.226 


# Using a Stack2 with the spush method is a somewhat faster. This method can only
# push a single item to the stack, and therefore doesn't need to deal with ...
# arguments.
system.time({
  s <- Stack2()
  for (i in 1:n) s$spush(i)
})
#    user  system elapsed 
#   3.718   0.043   3.782 
```

One might expect the `Stack2` to be much slower because the backing list should be copy-on-write. But (I believe) the reference counting in R is smart enough to know that if there are no other references to the list, then it is safe to modify the list in place.



The pairlist-backed `Stack` uses more memory than the list-backed `Stack2`. This is because **pairlist** is a linked list, where each element contains a pointer to the next element, while a **list** is essentially an array in C, which doesn't require pointers for each element.

```R
s <- Stack()
# Push 150 numbers on the stack
s$push(.list = as.list(1:150))
# Get the size of the underlying pairlist
object.size(s$s)
# 15600 bytes

s <- Stack2()
s$push(.list = as.list(1:150))
object.size(s$s)
# 8520 bytes
```



## Queues

### Pairlist-backed `Queue`

A `Queue` is similar to a `Stack`; it also is implemented using a pairlist, and is is wrapped in an environment (in an OOP style) which provides some methods for working with the queue. Any type of R object can be added to the queue.

```R
library(qstack)

# Create a queue
q <- Queue()

q$add(5)
q$add(10)
q$size()
# [1] 2

q$remove()
# [1] 5
q$remove()
# [1] 10
q$remove()
# NULL

q$add(15)
q$peek()
# [1] 15
q$remove()
# [1] 15
```

As with a `Stack`, the underlying pairlist for a `Queue` is manipulated in ways that would normally be dangerous in R, but the abstraction layer protects the user from the danger.


### List-backed `Queue2`

A `Queue2` has the same interface as a `Queue`, but it is implemented in pure R code. The underlying data structure is a list which is doubled (and copied) as the queue changes in size.


```R
# Create a queue
q <- Queue2()

q$add(5)
q$add(10)
q$size()
# [1] 2

q$remove()
# [1] 5
q$remove()
# [1] 10
q$remove()
# NULL

q$add(15)
q$peek()
# [1] 15
q$remove()
# [1] 15
```


### Comparing perfomance of `Queue` and `Queue2`

As is the case with a `Stack` and `Stack2`, the pairlist-backed `Queue` and list-backed `Queue2` have similar performance for adding items. However, the `Queue2` is slower for removing items.

```R
n <- 1e6

system.time({
  q <- Queue()
  for (i in 1:n) q$add(i)
})
#    user  system elapsed 
#   7.199   0.134   7.436 
system.time({
  for (i in 1:n) q$remove()
})
#    user  system elapsed 
#   1.741   0.013   1.761 


system.time({
  q <- Queue2()
  for (i in 1:n) q$add(i)
})
#    user  system elapsed 
#   6.336   0.172   6.607 
system.time({
  for (i in 1:n) q$remove()
})
#    user  system elapsed 
#   5.983   0.050   6.061 
```

As for memory usage, the pattern is the same as with stacks. The pairlist-backed `Queue` uses more memory than the list-backed `Queue2`.

```R
q <- Queue()
# Add 150 numbers to the queue
q$add(.list = as.list(1:150))
# Get the size of the underlying pairlist
object.size(q$q)
# 15600 bytes

q <- Queue2()
for (i in 1:150) q$add(i)  # Need loop because `.list` argument not yet implemented
object.size(q$q)
# 8520 bytes
```
