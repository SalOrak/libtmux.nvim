local M = {
    states = {
        FULLY = 1,
        PARTIAL = 2, 
        BUGGY   = 3,
        NOT_IMPLEMENTED = 4
    }
}


local states_table = {}

for k,v in pairs(M.states) do
    states_table[v] = k
end

M.get_state = function(state_num)
    return states_table[state_num]
end


return M
