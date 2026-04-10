---@type Base46Table
local M = {}

local base00 = "#1a1110"
local base02 = "#a59a99"
local base04 = "#fff0ef"
local base05 = "#fff9f8"
local base08 = "#ffa09f"
local base0A = "#ffbeb8"
local base0B = "#b8ffa5"
local base0C = "#ffdcd9"
local base0D = "#ffbeb8"
local base0E = "#ffc9c4"
local base0F = "#ffc9c4"

M.base_30 = {
  white = base05,
  darker_black = "#140d0c",
  black = base00,
  black2 = "#221716",
  one_bg = "#2c1f1d",
  one_bg2 = "#3a2927",
  one_bg3 = "#4a3633",
  grey = base02,
  grey_fg = base02,
  grey_fg2 = "#c2b7b6",
  light_grey = base04,
  red = base08,
  baby_pink = base0F,
  pink = base0E,
  line = "#3a2927",
  green = base0B,
  vibrant_green = "#d0ffc4",
  blue = base0D,
  nord_blue = base0C,
  yellow = base0A,
  sun = base0A,
  purple = base0E,
  dark_purple = base08,
  teal = base0C,
  orange = base08,
  cyan = base0C,
  statusline_bg = "#221716",
  lightbg = "#2c1f1d",
  pmenu_bg = base08,
  folder_bg = base0D,
}

M.base_16 = {
  base00 = base00,
  base01 = base00,
  base02 = base02,
  base03 = base02,
  base04 = base04,
  base05 = base05,
  base06 = base05,
  base07 = base05,
  base08 = base08,
  base09 = base08,
  base0A = base0A,
  base0B = base0B,
  base0C = base0C,
  base0D = base0D,
  base0E = base0E,
  base0F = base0F,
}

M.polish_hl = {
  defaults = {
    Visual = { bg = base02, fg = base05, bold = true },
    StatusLine = { bg = M.base_30.statusline_bg, fg = base05 },
    LineNr = { fg = base02 },
    CursorLineNr = { fg = base0C, bold = true },
    Comment = { fg = base02, italic = true },
    Macro = { fg = base0D, italic = true },
    NormalFloat = { bg = M.base_30.black2 },
    FloatBorder = { fg = base0A, bg = M.base_30.black2 },
    FloatTitle = { fg = base00, bg = base0E, bold = true },
    Pmenu = { bg = M.base_30.black2, fg = base05 },
    PmenuSel = { bg = base08, fg = base00, bold = true },
    PmenuSbar = { bg = M.base_30.one_bg },
    PmenuThumb = { bg = base0E },
    WinSeparator = { fg = base0A },
  },

  syntax = {
    Statement = { fg = base0E, bold = true },
    Keyword = { link = "Statement" },
    Repeat = { link = "Statement" },
    Conditional = { link = "Statement" },
    Function = { fg = base0D, bold = true },
    Type = { fg = base0C, bold = true, italic = true },
    Structure = { link = "Type" },
    String = { fg = base0B, italic = true },
    Operator = { fg = base04 },
    Delimiter = { fg = base04 },
    Macro = { fg = base0D, italic = true },
  },

  treesitter = {
    ["@function.macro"] = { link = "Macro" },
    ["@punctuation.bracket"] = { link = "Delimiter" },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
  },

  statusline = {
    StatusLine = { bg = M.base_30.statusline_bg, fg = base05 },
    St_gitIcons = { fg = base0E, bg = M.base_30.statusline_bg, bold = true },
    St_Lsp = { fg = base0A, bg = M.base_30.statusline_bg, bold = true },
    St_LspMsg = { fg = base0C, bg = M.base_30.statusline_bg },
    St_EmptySpace = { fg = M.base_30.grey, bg = M.base_30.lightbg },
    ST_EmptySpace = { fg = M.base_30.grey, bg = M.base_30.statusline_bg },
    St_file = { fg = base05, bg = M.base_30.lightbg, bold = true },
    St_file_sep = { fg = M.base_30.lightbg, bg = M.base_30.statusline_bg },
    St_cwd_icon = { fg = base00, bg = base08, bold = true },
    St_cwd_text = { fg = base05, bg = M.base_30.lightbg },
    St_cwd_sep = { fg = base08, bg = M.base_30.statusline_bg },
    St_pos_sep = { fg = base0B, bg = M.base_30.lightbg },
    St_pos_icon = { fg = base00, bg = base0B, bold = true },
    St_pos_text = { fg = base05, bg = M.base_30.lightbg },
    St_lspError = { fg = base08, bg = M.base_30.statusline_bg, bold = true },
    St_lspWarning = { fg = base0A, bg = M.base_30.statusline_bg, bold = true },
    St_LspHints = { fg = base0E, bg = M.base_30.statusline_bg, bold = true },
    St_LspInfo = { fg = base0C, bg = M.base_30.statusline_bg, bold = true },
    St_NormalMode = { fg = base00, bg = base0A, bold = true },
    St_NormalModeSep = { fg = base0A, bg = base02 },
    St_VisualMode = { fg = base00, bg = base0E, bold = true },
    St_VisualModeSep = { fg = base0E, bg = base02 },
    St_InsertMode = { fg = base00, bg = base0C, bold = true },
    St_InsertModeSep = { fg = base0C, bg = base02 },
    St_TerminalMode = { fg = base00, bg = base0B, bold = true },
    St_TerminalModeSep = { fg = base0B, bg = base02 },
    St_NTerminalMode = { fg = base00, bg = base0A, bold = true },
    St_NTerminalModeSep = { fg = base0A, bg = base02 },
    St_ReplaceMode = { fg = base00, bg = base08, bold = true },
    St_ReplaceModeSep = { fg = base08, bg = base02 },
    St_ConfirmMode = { fg = base00, bg = base0C, bold = true },
    St_ConfirmModeSep = { fg = base0C, bg = base02 },
    St_CommandMode = { fg = base00, bg = base0D, bold = true },
    St_CommandModeSep = { fg = base0D, bg = base02 },
    St_SelectMode = { fg = base00, bg = base0F, bold = true },
    St_SelectModeSep = { fg = base0F, bg = base02 },
  },

  tbline = {
    Tabline = { bg = M.base_30.black2, fg = base05 },
    TbFill = { bg = M.base_30.black2 },
    TbBufOn = { fg = base00, bg = base0E, bold = true },
    TbBufOff = { fg = base04, bg = M.base_30.black2 },
    TbBufOnModified = { fg = base00, bg = base0B, bold = true },
    TbBufOffModified = { fg = base08, bg = M.base_30.black2 },
    TbBufOnClose = { fg = base00, bg = base08, bold = true },
    TbBufOffClose = { fg = base02, bg = M.base_30.black2 },
    TbTabNewBtn = { fg = base00, bg = base08, bold = true },
    TbTabOn = { fg = base00, bg = base0D, bold = true },
    TbTabOff = { fg = base04, bg = M.base_30.black2 },
    TbTabCloseBtn = { fg = base00, bg = base08, bold = true },
    TBTabTitle = { fg = base00, bg = base0E, bold = true },
    TbThemeToggleBtn = { fg = base00, bg = base0E, bold = true },
    TbCloseAllBufsBtn = { fg = base00, bg = base08, bold = true },
  },

  cmp = {
    CmpBorder = { fg = base0A, bg = M.base_30.black2 },
    CmpDoc = { bg = M.base_30.black2 },
    CmpDocBorder = { fg = base0A, bg = M.base_30.black2 },
    CmpPmenu = { bg = M.base_30.black2 },
    CmpSel = { bg = base08, fg = base00, bold = true },
    CmpItemAbbr = { fg = base05 },
    CmpItemAbbrMatch = { fg = base0E, bold = true },
  },

  telescope = {
    TelescopeNormal = { bg = M.base_30.black2 },
    TelescopeBorder = { fg = base0A, bg = M.base_30.black2 },
    TelescopePromptBorder = { fg = base0A, bg = M.base_30.black2 },
    TelescopePromptNormal = { fg = base05, bg = M.base_30.black2 },
    TelescopePromptPrefix = { fg = base08, bg = M.base_30.black2 },
    TelescopePromptTitle = { fg = base00, bg = base08, bold = true },
    TelescopePreviewTitle = { fg = base00, bg = base0D, bold = true },
    TelescopeResultsTitle = { fg = base00, bg = base0E, bold = true },
    TelescopeSelection = { fg = base05, bg = M.base_30.one_bg, bold = true },
    TelescopeMatching = { fg = base0A, bold = true },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "dankcolors")

return M
