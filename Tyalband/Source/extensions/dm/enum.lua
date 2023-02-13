-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

-- Creates a C like enum (capitalize both variable and children)

enum = {}

function enum.new(t)
    local result = {}
    for index, name in pairs(t) do
        result[name] = index
    end
    return result
end

function enum.getName(enum, value)
    for name, v in pairs(enum) do
        if (value == v) then return name end
    end
end