class Exception
  def full_trace
    message + "\n" + backtrace.join("\n")
  end
end