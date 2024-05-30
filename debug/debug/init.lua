function debug.dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. debug.dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function debug.send(s)
   minetest.chat_send_all(debug.dump(s))
end
