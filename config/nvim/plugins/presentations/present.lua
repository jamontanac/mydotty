local M = {}

M.setup = function()
    --keymaps
    -- vim.keymap.set('n', '<leader>pt', function() require('presentations.present').start_presentation() end, { desc = 'Start Presentation Mode' })
    -- vim.keymap.set('n', '<leader>pq', function() require('presentations.present').stop_presentation() end, { desc = 'Stop Presentation Mode' })
end
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    -- local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)

    return {
        buf = buf,
        win = vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = width,
            height = height,
            col = col,
            row = row,
            style = 'minimal',
            border = opts.border or 'rounded',
            title = opts.title or 'Slides',
            title_pos = 'center',
        }),
    }
end

-- @class present.Slides
-- @fields Slides string[]:  the slides of the file
-- Takes some lines and parses them
-- @param lines string[]: The lines in the buffer
-- @return present.Slides
local parse_slides = function(lines)
    --
    local slides = { slides = {} }
    local current_slide = {}
    local separator = '^#' -- Slides start with a line that begins with '#'

    for _, line in ipairs(lines) do
        -- print(line)
        if line:find(separator) then
            if #current_slide > 0 then
                if #current_slide > 0 then
                    table.insert(slides.slides, current_slide)
                end
                current_slide = {}
            end
        end
        table.insert(current_slide, line)
    end
    table.insert(slides.slides, current_slide) -- Insert the last slide

    return slides
end

M.start_presentation = function(opts)
    -- Get the current buffer lines
    opts = opts or {}
    opts.bufnr = opts.bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
    local slides = parse_slides(lines)
    local floating_window = create_floating_window { title = 'Presentation' }
    -- local current_slide = 1
    -- vim.keymap.set('n', 'n', function()
    --     current_slide = math.min(current_slide + 1, #slides.slides)
    --     vim.api.nvim_buf_set_lines(floating_window.buf, 0, -1, false, slides.slides[current_slide])
    -- end, { buffer = floating_window.buf, desc = 'Next Slide' })
    --
    -- vim.keymap.set('n', 'p', function()
    --     current_slide = math.max(current_slide - 1, 1)
    --     vim.api.nvim_buf_set_lines(floating_window.buf, 0, -1, false, slides.slides[current_slide])
    -- end, { buffer = floating_window.buf, desc = 'Previous Slide' })
    --
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(floating_window.win, true)
    end, { buffer = floating_window.buf, desc = 'Quit Presentation' })

    vim.api.nvim_buf_set_lines(floating_window.buf, 0, -1, false, slides.slides[1])
end

-- M.start_presentation { bufnr = 6 }
return M
