function Logging_write(fb::IOStream,x...)
  println(fb, x...)
end

function Logging_write(fb::IOStream,x::Vector)
  for i in x
    println(fb,i)
  end
end
