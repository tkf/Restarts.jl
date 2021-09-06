function Restarts.restart(exception::Exception, restarts::Pair...)
    for (cvar, cont) in restarts
        f = cvar[]
        f === nothing && continue
        y = f(exception)::Union{Some,Nothing}
        y === nothing && continue
        return cont(something(y))
    end
    throw(exception)
end

macro define_restart(name::Symbol)
    m = @__MODULE__
    quote
        $m.@contextvar $name::$Any = nothing
    end |> esc
end

# TODO: type check?
Restarts.with(f, restarts::Pair...) = with_context(f, restarts...)
