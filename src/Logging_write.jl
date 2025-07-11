function logging(log::Logfile, level::Level, text::AbstractString;format::Format= Format())
  if log.level>level
    return nothing
  end
  println(log.io, format.indentation, text)
  flush(log.io)
  check(log);
end

_logging(log::Logfile,text::AbstractString;format::Format= Format()) = print(log.io,format.indentation,text)

function logging(log::Logfile,level::Level, number::T where T<:Real;format::Format= Format())
  if log.level>level
    return nothing
  end
  print(log.io,format.indentation)
  @printf(log.io, "%.12e, \n", number)
  flush(log.io)
  check(log);
end

function _logging(log::Logfile,number::T where T<:Real;format::Format= Format()) 
  print(log.io, format.indentation)
  @printf(log.io, "%.12e ", number)
end

function logging(log::Logfile,level::Level,obs::ADerrors.uwreal;format::Format= Format())
  if log.level>level
    return nothing
  end
  print(log.io, format.indentation)
  if obs.mean < 0
    @printf(log.io, "%.12e +- %.12e, \n",value(obs),Err(obs))
  else
    @printf(log.io, " %.12e +- %.12e, \n",value(obs),Err(obs))
  end 
  flush(log.io)
  check(log);
end

function _logging(log::Logfile,obs::ADerrors.uwreal;format::Format= Format())
  print(log.io, format.indentation)
  if obs.mean < 0
    @printf(log.io, "%.12e +- %.12e, ",obs.mean,obs.err)
  else
    @printf(log.io, " %.12e +- %.12e, ",obs.mean,obs.err)
  end 
end

function logging(log::Logfile,level::Level, x...;format::Format =Format())
  if log.level>level
    return nothing
  end
  print(log.io,format.indentation)
  for token in x
    _logging(log,token)
  end
  print(log.io,'\n')
  flush(log.io)
  check(log);
end

function logging(log::Logfile,level::Level,x;format::Format =Format())
  if log.level>level
    return nothing
  end
  print(log.io,format.indentation)
  println(log.io,x)
  flush(log.io)
  check(log);
end

function logging(log::Logfile,level::Level,x::AbstractArray;format::Format =Format())
  if log.level>level 
    return nothing
  end
  ndim = ndims(x)
  if ndim == 2
    _logging(log::Logfile,x;format = Format(format.indentation*'\t'))
  else
    for n in axes(x,1)
      print(log.io, "axes: $n ")
      [_logging(log,s;format = Format(format.indentation*'\t')) for s in eachslice(x,dims=1)] 
    end
  end  
end

function _logging(log::Logfile,x::AbstractMatrix;format::Format =Format())
  print(log.io,'\n',format.indentation)
  for i in axes(x,1)
    for j in axes(x,2)
      _logging(log,x[i,j])
    end
    print(log.io,'\n',format.indentation)
  end
end

# function _logging(log::Logfile,x::AbstractArray;format::Format=Format())
#   for n in axes(x,1)
#     print(log.io, "- $n ")
#     [_logging(log,s,format=format) for s in eachslice(x,dims=1)] 
#   end
# end

_logging(log::Logfile,x) = print(log.io, x, " ")

logging(x::Nothing,y...;k...) = nothing

log_debug(log,x...;format=Format())   = logging(log,Level_debug,x...;format=format)
log_info( log,x...;format=Format())   = logging(log,Level_info,x...;format=format)
log_warn( log,x...;format=Format())   = logging(log,Level_warn,x...;format=format)
log_error(log,x...;format=Format())   = logging(log,Level_error,x...;format=format)

Base.println(log::Logfile, x...) = logging(log,Level_debug,x...)
Base.print(log::Logfile, x...)   = logging(log,Level_debug,x...)
Base.show(io::Core.IO,log::Logfile)= println(io,"log file in",path(log))
