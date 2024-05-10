export const SEPARATOR_TEXT = {
  Hyphen: 'hyphen',
  Underscore: 'underscore',
  Period: 'period',
} as const;

export type SeparatorText = typeof SEPARATOR_TEXT[keyof typeof SEPARATOR_TEXT];

export function isSeparator(separator: string): separator is SeparatorText {
  return Object.values(SEPARATOR_TEXT).includes(separator as SeparatorText);
}

export const SEPARATOR = {
  [SEPARATOR_TEXT.Hyphen]: '-',
  [SEPARATOR_TEXT.Underscore]: '_',
  [SEPARATOR_TEXT.Period]: '.',
} as const;

export type Separator = typeof SEPARATOR[keyof typeof SEPARATOR];
