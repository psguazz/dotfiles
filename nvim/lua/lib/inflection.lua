local IRREGULAR = {
  person = "people",
  man = "men",
  child = "children",
  mouse = "mice",
}

local UNCOUNTABLE = {
  information = true,
  rice = true,
  money = true,
  species = true,
  series = true,
  fish = true,
}

local function detect_inflection(word)
  word = word:lower()

  if UNCOUNTABLE[word] then
    return "uncountable"
  end

  for s, p in pairs(IRREGULAR) do
    if word == s then return "singular" end
    if word == p then return "plural" end
  end

  if word:match("ies$") then return "plural" end
  if word:match("es$") then return "plural" end
  if word:match("s$") then return "plural" end

  return "singular"
end

local function pluralize(word)
  word = word:lower()
  if detect_inflection(word) ~= "singular" then return word end

  if IRREGULAR[word] then
    return IRREGULAR[word]
  end

  if word:match("y$") then
    return word:sub(1, -2) .. "ies"
  end

  if word:match("[sxz]$") or word:match("[cs]h$") then
    return word .. "es"
  end

  return word .. "s"
end

local function singularize(word)
  word = word:lower()
  if detect_inflection(word) ~= "plural" then return word end

  for s, p in pairs(IRREGULAR) do
    if word == p then return s end
  end

  if word:match("ies$") then
    return word:sub(1, -4) .. "y"
  end

  if word:match("es$") then
    return word:sub(1, -3)
  end

  if word:match("s$") then
    return word:sub(1, -2)
  end

  return word
end

local function inflections(word)
  word = word:lower()

  local singular = singularize(word)
  local plural = pluralize(word)

  if singular == plural then
    return { word }
  else
    return { singular, plural }
  end
end

M = {
  detect_inflection = detect_inflection,
  pluralize = pluralize,
  singularize = singularize,
  inflections = inflections,
}

return M
