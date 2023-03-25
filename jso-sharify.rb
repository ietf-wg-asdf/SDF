require 'json'
require 'yaml'


def json_sharify(o, aliases, hint = nil)
  ret, = aliases[o]
  if ret
    aliases[o][1] += 1
    aliases[o][2] << hint if hint
  else
    ret =
    case o
    in Array
      o.map {|el| json_sharify(el, aliases)}
    in Hash
      Hash[o.map {|k, v| [json_sharify(k, aliases), json_sharify(v, aliases, (k if String === k))] }]
    else
      o
    end
    aliases[o] = [ret, 1, hint ? Set[hint] : Set[]]
  end
  ret
end

GENSYM = +"gensym00"

def hint_to_string(hint)
  hint.join("-")
end

def hint_size(hint)
  if hint
    hint_to_string(hint).size
  else
    0
  end
end

def sharify_round(input)

  item = JSON.parse(input)
  unsharified = JSON.dump(item)

  ##  warn "*** Unsharified size = #{unsharified.size}"

  aliases = Hash.new
  ret = json_sharify(item, aliases)

  fail if unsharified != JSON.dump(ret)

  # puts ret.to_yaml

  top = aliases.sort_by {|k, (k1, count, hint)|  # puts [k, count, hint].inspect if hint
    (-k.to_json.size + hint_size(hint) + 40) * (count - 1) }

  to_replace = top[0]
  orig, (replace_point, count, hint) = to_replace

  return :count if count < 2
  return :nohash unless Hash === orig

  ## warn [count, hint_to_string(hint), orig].to_yaml

  newsym = GENSYM.succ!.dup
  if hint
    hint_prefix = hint_to_string(hint) << "-"
    if /\A[a-z][-a-z0-9]*\z/i === hint_prefix
      if ret["definitions"][hint_prefix] # be prepared
        newsym[0,0] = hint_prefix
      else
        newsym = hint_prefix
      end
    end
  end

  replacement = {
    "$ref" => "#/definitions/#{newsym}"
  }

  return :growing if JSON.dump(replacement).size >= JSON.dump(orig).size

  replace_point.replace(replacement)

  # puts orig.to_yaml

  ret["definitions"][newsym] = orig

  sharified = JSON.dump(ret)

  ## warn "*** sharified.size = #{sharified.size}"

  # puts ret.to_yaml

  JSON.dump(ret)
end


input = ARGF.read
warn "*** pretty(?) input size: #{input.size}"
input = JSON.dump(JSON.parse(input))
warn "*** compact size: #{input.size}"

loop do
  attempt = sharify_round(input)
  if Symbol === attempt
    warn "*** ending on #{attempt}"
    break
  end
  if attempt.size >= input.size
    warn "*** ending on increased size"
    break
  end
  input = attempt
end

warn "*** sharified size (#{GENSYM}): #{input.size}"

output = JSON.pretty_generate(JSON.parse(input))

warn "*** pretty output size: #{output.size}"

puts output
