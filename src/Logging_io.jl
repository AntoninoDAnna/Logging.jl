function Logging_open(path::AbstractString, mode::AbstractString)
  if mode == "w" && isfile(path)
    @info("Overriding log file")
  end
  if !isfile(path)
    @info("creating log file")
  end

  return open(path,mode)
end

function Logging_close!(log::IOStream)
  close(log)
end