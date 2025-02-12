module Logging 

using Printf
import ADerrors
import Base: print

include("Logging_io.jl")
include("Logging_write.jl")

export Logfile, Level, Level_debug, Level_info,Level_warn, Level_error, Logging_close!, Format
export logging, log_debug, log_info, log_warn, log_error

end # module Logging