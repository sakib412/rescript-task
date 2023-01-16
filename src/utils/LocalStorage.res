@scope(("window", "localStorage")) @val
external setItem: (string, string) => unit = "setItem"

@val @scope(("window", "localStorage"))
external removeItem: string => unit = "removeItem"

@val @scope(("window", "localStorage")) @return(nullable)
external getItem: string => option<string> = "getItem"
