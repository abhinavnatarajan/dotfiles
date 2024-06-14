local icons = require("icons")
local M = {}

M.CompletionItemKind = {
	Function      = { icon = icons.syntax.Function, desc = 'Command', },
	Value         = { icon = icons.syntax.Variable, desc = 'Command Argument', },
	Snippet       = { icon = icons.syntax.Snippet, desc = 'Snippet', },
	Enum          = { icon = icons.syntax.Namespace, desc = 'Environment', },
	Module        = { icon = icons.ui.Section, desc = 'Section', },
	Method        = { icon = icons.ui.Picture, desc = 'Float', },
	Variable      = { icon = icons.syntax.Method, desc = 'Theorem', },
	Constant      = { icon = icons.syntax.Operator, desc = 'Equation', },
	EnumMember    = { icon = icons.ui.GroupList, desc = 'Enumeration Item', },
	Constructor   = { icon = icons.syntax.Key, desc = 'Label', },
	Folder        = { icon = icons.syntax.Folder, desc = 'Folder', },
	File          = { icon = icons.syntax.File, desc = 'File', },
	Property      = { icon = icons.ui.Shape, desc = 'PGF/TikZ Library', },
	Color         = { icon = icons.syntax.Color, desc = 'Color/Color Model', },
	Class         = { icon = icons.syntax.Class, desc = 'Package/Class', },
	Interface     = { icon = icons.ui.Books, desc = 'BibTeX Entry (Misc)', },
	Event         = { icon = icons.ui.Books, desc = 'BibTeX Entry (Article)', },
	Struct        = { icon = icons.ui.Books, desc = 'BibTeX Entry (Book)', },
	TypeParameter = { icon = icons.ui.Books, desc = 'BibTeX Entry (Collection)', },
	Operator      = { icon = icons.ui.Books, desc = 'BibTeX Entry (Part)', },
	Unit          = { icon = icons.ui.Books, desc = 'BibTeX Entry (Thesis)', },
	Text          = { icon = icons.ui.Books, desc = 'BibTeX String', },
	Field         = { icon = icons.ui.Books, desc = 'BibTeX Field', },
}

M.config = {
	settings = {
		texlab = {
			experimental = {
				labelReferenceCommands = { "fullref" }, -- custom command that I defined in a paper
				mathEnvironments = { "diagram" },
			},
		},
	},
}

return M
