baremodule Restarts

export  restart, @define_restart

function with end
function restart end
macro define_restart end

module Internal

using ..Restarts: Restarts
import ..Restarts: @define_restart

using ContextVariablesX: @contextvar, with_context

include("internal.jl")

end  # module Internal

end  # baremodule Restarts
