function logging(log::Logfile, level::Level, text::AbstractString)
  if log.level>level
    return nothing
  end
  println(log.io, text)
  flush(log.io)
end

_logging(log::Logfile,text::AbstractString) = print(log.io,text)

function logging(log::Logfile,level::Level, number::T where T<:Real)
  if log.level>level
    return nothing
  end
  @printf(log.io, "%.12f, \n", number)
  flush(log.io)
end

_logging(log::Logfile,number::T where T<:Real) = @printf(log.io, "%.12f", number)

function logging(log::Logfile,level::Level,obs::uwreal)
  if log.level>level
    return nothing
  end
  @printf(log.io, "%.12f +- %.12f, \n",value(obs),Err(obs))
  flush(log.io)
end

_logging(log::Logfile,obs::uwreal) = @printf(log.io, "%.12f +- %.12f", value(obs),Err(obs))

function logging(log::Logfile,level::Level, x...)
  if log.level>level
    return nothing
  end
  for token in x
    _logging(log,token)
  end
  print(log.io,'\n')
  flush(log.io)
end

function logging(log::Logfile,level::Level,x)
  if log.level>level
    return nothing
  end
  println(log.io,x)
  flush(log.io)
end

_logging(log::Logfile,x) = print(log.io, x)

log_debug(log::Logfile,x...)   = logging(log,Level_debug,x...)
log_info(log::Logfile,x...)    = logging(log,Level_info,x...)
log_warn(log::Logfile,x...)    = logging(log,Level_warn,x...)
log_error(log::Logfile,x...)   = logging(log,Level_error,x...)