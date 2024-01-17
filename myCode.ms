let factorial = func: n -> {
    if n == 0 || n == 1 {return 1}
    else {return n * recur(n-1)}
}
# 7!
output(factorial(7))