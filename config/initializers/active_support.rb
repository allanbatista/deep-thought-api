class ActiveSupport::TimeWithZone
  def to_s
    to_datetime.to_s
  end

  def as_json(options = {})
    to_s
  end
end
