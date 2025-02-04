@enum Level begin
  Level_debug  
  Level_info
  Level_warn
  Level_error
end

const MAXFILE_SIZE = 100 ## in megabyte
const NEXTCHECK  = 100_000 ## how many time it will check
mutable struct Format 
  indentation::String
  Format() = new("");
  Format(i::String) = new(i);
end


mutable struct Logfile
  io::IOStream
  filename::AbstractString
  dirname::AbstractString
  extention::AbstractString
  level::Level 
  maxfile::Int64  #size in megabyte
  itr::Int64
  next_check::Int64
  function Logfile(path::AbstractString,mode::AbstractString, level::Level)
    if mode == "w" && isfile(path)
      @warn "File already exist. Overriding..."
    end
    dir = dirname(path);
    dir = dir =="" ? "." : dir
    if !isdir(dir)
      error("Directory $(dir) does not exist")
    end   
    io = open(path,mode)
    filename = basename(path)
    ext= split(filename,".")[end]
    filename = filename[1:end-length(ext)-1]
    return new(io,filename,dir, ext,level,MAXFILE_SIZE,1,NEXTCHECK)
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

Logging_close!(log::Nothing)  =nothing

function change_file(log::Logfile)
  log.itr+= 1;
  filename = log.filename
  path_new = filename*"_it_$(log.itr)."*log.extention
  println(log.io, "Changing log file")
  @info """
    Log file too large: new log file at $path_new
  """
  close(log.io)
  log.next_check = NEXTCHECK
  log.io = open(path_new,"w")
end
 
path(log::Logfile) = "$(log.dirname)/$(log.filename).$(log.extention)"

function check(log::Logfile)
  log.next_check-=1;
  if log.next_check>0
    return;
  end
  if filesize( Logging.path(log))/(1024^2)> log.maxfile
    change_file(log)
  end
end
