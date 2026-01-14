local IRREGULAR = {
  child = "children",
  man = "men",
  mouse = "mice",
  person = "people",
  woman = "women",
}

local UNCOUNTABLE = {
  fish = true,
  information = true,
  money = true,
  rice = true,
  series = true,
  species = true,
}

local SINGULAR = {
  ies = { "[^aeiou]y$" },
  es = { "[sxz]$", "[cs]h$" },
}

local PLURAL = {
  ies = { "[^aeiou]ies$" },
  es = { "[sxz]es$", "[cs]hes$" },
  s = { "[^s]s$" }
}

local function detect_inflection(word)
  word = word:lower()

  if word == "" then return "uncountable" end
  if UNCOUNTABLE[word] then return "uncountable" end

  for s, p in pairs(IRREGULAR) do
    if word == s then return "singular" end
    if word == p then return "plural" end
  end

  for _, patterns in ipairs({ PLURAL.ies, PLURAL.es, PLURAL.s }) do
    for _, pattern in ipairs(patterns) do
      if word:match(pattern) then return "plural" end
    end
  end

  return "singular"
end

local function pluralize(word)
  word = word:lower()
  if detect_inflection(word) ~= "singular" then return word end

  if IRREGULAR[word] then
    return IRREGULAR[word]
  end

  for _, pattern in ipairs(SINGULAR.ies) do
    if word:match(pattern) then
      return word:sub(1, -2) .. "ies"
    end
  end

  for _, pattern in ipairs(SINGULAR.es) do
    if word:match(pattern) then
      return word .. "es"
    end
  end

  return word .. "s"
end

local function singularize(word)
  word = word:lower()
  if detect_inflection(word) ~= "plural" then return word end

  for s, p in pairs(IRREGULAR) do
    if word == p then return s end
  end

  for _, pattern in ipairs(PLURAL.ies) do
    if word:match(pattern) then
      return word:sub(1, -4) .. "y"
    end
  end

  for _, pattern in ipairs(PLURAL.es) do
    if word:match(pattern) then
      return word:sub(1, -3)
    end
  end

  for _, pattern in ipairs(PLURAL.s) do
    if word:match(pattern) then
      return word:sub(1, -2)
    end
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
