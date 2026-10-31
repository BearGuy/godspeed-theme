local M = {}

function M.setup(variant)
  variant = variant or (vim.o.background == "light" and "whirlwind" or "thunderbolt")
  if variant ~= "thunderbolt" and variant ~= "whirlwind" then
    error("godspeed: variant must be 'thunderbolt' or 'whirlwind'")
  end

  local palette_file = vim.api.nvim_get_runtime_file("palettes/" .. variant .. ".json", false)[1]
  if not palette_file then
    error("godspeed: palette not found for " .. variant)
  end
  local p = vim.json.decode(table.concat(vim.fn.readfile(palette_file), "\n"))
  vim.o.background = p.appearance
  vim.cmd("highlight clear")
  vim.g.colors_name = "godspeed-" .. variant
  for i, color in ipairs(p.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end

  local groups = {
    Normal = { fg = p.foreground, bg = p.background },
    NormalNC = { fg = p.foreground, bg = p.background },
    NormalFloat = { fg = p.foreground, bg = p.surface },
    FloatBorder = { fg = p.border, bg = p.surface },
    CursorLine = { bg = p.surface },
    CursorColumn = { bg = p.surface },
    ColorColumn = { bg = p.surface },
    LineNr = { fg = p.comment },
    CursorLineNr = { fg = p.cyan, bold = true },
    SignColumn = { bg = p.background },
    FoldColumn = { fg = p.comment, bg = p.background },
    Folded = { fg = p.muted, bg = p.surface },
    EndOfBuffer = { fg = p.border },
    Visual = { bg = p.selection },
    Search = { fg = p.foreground, bg = p.selection },
    IncSearch = { fg = p.background, bg = p.amber, bold = true },
    CurSearch = { fg = p.background, bg = p.cyan, bold = true },
    Pmenu = { fg = p.foreground, bg = p.surface },
    PmenuSel = { fg = p.foreground, bg = p.selection },
    PmenuSbar = { bg = p.surface_alt },
    PmenuThumb = { bg = p.muted },
    StatusLine = { fg = p.foreground, bg = p.surface_alt },
    StatusLineNC = { fg = p.muted, bg = p.surface },
    WinSeparator = { fg = p.border },
    VertSplit = { fg = p.border },
    TabLine = { fg = p.muted, bg = p.surface },
    TabLineSel = { fg = p.cyan, bg = p.surface_alt, bold = true },
    TabLineFill = { bg = p.surface },
    Title = { fg = p.violet, bold = true },
    Directory = { fg = p.cyan },
    NonText = { fg = p.comment },
    SpecialKey = { fg = p.comment },
    Comment = { fg = p.comment, italic = true },
    Constant = { fg = p.amber },
    String = { fg = p.green },
    Character = { fg = p.green },
    Number = { fg = p.amber },
    Boolean = { fg = p.amber },
    Identifier = { fg = p.foreground },
    Function = { fg = p.cyan },
    Statement = { fg = p.violet },
    Keyword = { fg = p.violet },
    Operator = { fg = p.muted },
    PreProc = { fg = p.violet },
    Type = { fg = p.ice },
    Special = { fg = p.cyan },
    Delimiter = { fg = p.muted },
    Error = { fg = p.red },
    ErrorMsg = { fg = p.red, bold = true },
    WarningMsg = { fg = p.amber },
    MoreMsg = { fg = p.green },
    Question = { fg = p.cyan },
    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.amber },
    DiagnosticInfo = { fg = p.cyan },
    DiagnosticHint = { fg = p.violet },
    DiagnosticUnderlineError = { undercurl = true, sp = p.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.amber },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.cyan },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.violet },
    DiffAdd = { fg = p.green, bg = p.surface },
    DiffChange = { fg = p.cyan, bg = p.surface },
    DiffDelete = { fg = p.red, bg = p.surface },
    DiffText = { fg = p.foreground, bg = p.selection },
  }
  local links = {
    ["@comment"] = "Comment", ["@string"] = "String", ["@string.special"] = "Special",
    ["@number"] = "Number", ["@boolean"] = "Boolean", ["@constant"] = "Constant",
    ["@function"] = "Function", ["@function.call"] = "Function", ["@function.method"] = "Function",
    ["@keyword"] = "Keyword", ["@operator"] = "Operator", ["@type"] = "Type",
    ["@type.builtin"] = "Type", ["@property"] = "Identifier", ["@variable"] = "Identifier",
    ["@punctuation"] = "Delimiter", ["@tag"] = "Keyword", ["@tag.attribute"] = "Type",
    ["@markup.heading"] = "Title", ["@markup.link"] = "Function", ["@markup.raw"] = "String",
    ["@lsp.type.function"] = "Function", ["@lsp.type.method"] = "Function",
    ["@lsp.type.class"] = "Type", ["@lsp.type.type"] = "Type",
    ["@lsp.type.keyword"] = "Keyword", ["@lsp.type.string"] = "String",
    ["@lsp.type.variable"] = "Identifier", ["@lsp.type.property"] = "Identifier",
  }
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
  for name, link in pairs(links) do
    vim.api.nvim_set_hl(0, name, { link = link })
  end
end

return M
