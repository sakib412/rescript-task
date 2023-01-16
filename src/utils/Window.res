@scope("window") @val
external alert: string => unit = "alert"

@scope("window") @val
external confirm: string => bool = "confirm"
