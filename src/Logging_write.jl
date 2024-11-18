function log(log::Logfile, level::Level, text::AbstractString)
  if log.level>=level
    return nothing
  end
  println(log.file, text)
  flush(log.file)
end

_log(log::Logfile,text::AbstractString) = print(log.file,text)

function log(log::Logfile,level::Level, number::T<:Real)
  if log.level>=level
    return nothing
  end
  @printf(log.file, "%.12f, \n", number)
  flush(log.file)
end

_log(log::Logfile,number::T<:Real) = @printf(log.file, "%.12f", number)

function log(log::Logfile,level::Level,obs::uwreal)
  if log.level>=level
    return nothing
  end
  @printf(log.file, "%.12 +- %.12, \n",value(obs),Err(obs))
  flush(log.file)
end

_log(log::Logfile,obs::uwreal) = @printf(log.file, "%.12 +- %.12", value(obs),Err(obs))