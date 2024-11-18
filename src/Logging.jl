module Logging 

using Printf
import ADerrors: uwreal, value, err as Err

include("Logging_io.jl")
include("Logging_write.jl")

export Logfile, Level, Level_debug, Level_info,Level_warn, Level_error, Logging_close!
export logging, debug, info, warn, error

end # module Logging
