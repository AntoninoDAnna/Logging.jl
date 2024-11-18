@enum Level begin
  debug=0,  
  info,
  warn,
  error
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
  Logfile(path::AbstractString) = Logfile(path,"w",warn)
  Logfile(path::AbstractString,level::Level) = Logfile(path,"w",level)
  Logfile(path::AbstractString,mode::AbstractString) = Logfile(path,mode,warn)
end

function Logging_close!(log::Logfile)
  if log.level<=debug
    println(log.io,"closing logfile")
    @info "$(log.name) is being closed"
  end
  close(log.io)
end