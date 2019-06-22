module Mongoid
  module Document
    def as_json(options={})
      format_attrs(super(options))
    end

    def format_attrs(attrs)
      if attrs.is_a?(Array)
        attrs.map { |attr| format_attrs(attr) }       
      elsif attrs.is_a?(Hash)
        attrs.keys.each do |key|
          value = format_attrs(attrs[key])

          if key == "_id"
            attrs.delete("_id")
            attrs["id"] = value
          else
            attrs[key] = value
          end
        end
        attrs
      elsif attrs.is_a?(BSON::ObjectId)
        attrs.to_s
      else
        attrs
      end
    end
  end
 end
