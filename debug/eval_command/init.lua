---@diagnostic disable:undefined-global

local global_env = {}

local function func(name, param)
    local env = {
        name = name,
        player = minetest.get_player_by_name(name),
    }

    for k, v in pairs(_ENV or _G) do
        env[k] = v
    end

    for k, v in pairs(global_env) do
        env[k] = v
    end

    function env.send(...)
        local message = ""

        for _, v in ipairs({...}) do
            message = message .. tostring(v)
        end

        if string.len(message) > 0 then
            minetest.chat_send_player(name, message)
        end
    end

    function env.keys(table)
        for key, _ in pairs(table) do
            if type(key) ~= "table" then
                env.send(key)
            end
        end
    end

    function env.dump(object)
        env.send(debug.dump(object))
    end

    function env.set(key, value)
        global_env[key] = value
    end

    ---@diagnostic disable-next-line:deprecated
    local command = loadstring(param)

    if not command then
        local error = minetest.colorize(
            "red",
            "[eval_command] ERROR: Failed to make loadstring function"
        )

        env.send(error)

        return
    end

    ---@diagnostic disable-next-line
    local final_command = setfenv(command, env)

    local status, result = pcall(final_command)

    if status then
        if result then
            env.dump(result)
        end
    else
        local error = minetest.colorize(
            "red",
            "[eval_command] ERROR: " .. result
        )

        env.send(error)
    end
end

minetest.register_chatcommand("eval", { func = func })
