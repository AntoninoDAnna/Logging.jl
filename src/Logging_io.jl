@enum Level begin
  Level_debug  
  Level_info
  Level_warn
  Level_error
end

mutable struct Format 
  indentation::String
  Format() = new("");
  Format(i::String) = new(s);
end


struct Logfile
  io::IOStream
  name::AbstractString
  level::Level 
  function Logfile(path::AbstractString,mode::AbstractString, level::Level)
    if mode == "w" && isfile(path)
      @warn "File already exist. Overriding..."
    end
    if !isdir(dirname(path))
      error("Directory $(dirname(path)) does not exist")
    end   
    io = open(path,mode)
    return new(io,basename(path), level)
  end
  Logfile(path::AbstractString) = Logfile(path,"w",Level_debug)
  Logfile(path::AbstractString,level::Level) = Logfile(path,"w",level)
  Logfile(path::AbstractString,mode::AbstractString) = Logfile(path,mode,Level_debug)
end

function Logging_close!(log::Logfile)
  if log.level<=Level_debug
    println(log.io,"closing logfile")
  end
  close(log.io)
end