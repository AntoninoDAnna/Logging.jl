module Logging

include("Logging_io.jl")
export Logging_open, Logging_close!
include("Logging_write.jl")
export Logging_write
end # module Logging
