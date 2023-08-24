import { random } from "./random.ts";

// separator "-", ".", ",", ":", "|", "\", "/", ">", "<", "@"
type Separator = "-" | "_" | "|" | "/" | "." | ",";

export const pairs = (
    a: string[],
    b: string[],
    separator: Separator = "-",
) => {
    return [random(a), random(b)].join(separator);
};
