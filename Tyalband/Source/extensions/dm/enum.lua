-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

-- Creates a C like enum (capitalize both variable and children)

---@class enum
enum = {}

-- Can be utilized in local const and added to a class for a read-only pointer enum
---@param t table
---@return table
function enum.new(t)
    local result = {}
    for index, name in pairs(t) do
        result[name] = index
    end
    return result
end

---@param enum enum
---@return table
function enum.copy(enum)
    return { table.unpack(enum) }
end

---@param enum enum
---@param value integer
---@return string | nil
function enum.getName(enum, value)
    for name, v in pairs(enum) do
        if (value == v) then 
            return name 
        end
    end
end