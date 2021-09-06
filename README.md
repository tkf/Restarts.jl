# Restarts

Restarts.jl implements Common Lisp's
[*restarts*](https://gigamonkeys.com/book/beyond-exception-handling-conditions-and-restarts.html)
based on [ContextVariablesX.jl](https://github.com/tkf/ContextVariablesX.jl)
which provides a thread-safe API for setting contextual information within a
dynamic scope.

Restarts.jl is inspired by
[Condition Systems in an Exceptional Language - Chris Houser - YouTube](https://www.youtube.com/watch?v=zp0OEDcAro0)
which explains that conditions can be simulated by dynamically scoped variables.

See [`examples/logparsing.jl`](examples/logparsing.jl) for an example.
