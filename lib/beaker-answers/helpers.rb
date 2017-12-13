def flatten_keys_to_joined_string(h, key_delim = '::')
  flat = {}
  h.each_pair do |k, v|
    if v.respond_to?(:keys)
      flatten_keys_to_joined_string(v, key_delim).each_pair do |k2, v2|
        flat.merge!([k.to_s, k2.to_s].join(key_delim) => v2)
      end
    else
      flat.merge!(k.to_s => v)
    end
  end

  flat
end
