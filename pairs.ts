import { random } from './random.ts';
import { Separator } from './separator.ts';

export const pairs = (a: string[], separator: Separator = '-') =>
(
  b: string[],
) => {
  return [random(a), random(b)].join(separator);
};
